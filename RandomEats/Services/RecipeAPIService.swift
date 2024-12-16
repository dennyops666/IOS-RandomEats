import Foundation
import Combine

class RecipeAPIService {
    private let session: URLSession
    private let cache = NSCache<NSString, AnyObject>()
    private let cacheKey = "randomRecipes"
    private var loadedRecipes: [String: [Recipe]] = [:] // 按类别存储菜谱
    private var retryAttempt = 0
    private let maxRetries = AppConfig.API.maxRetries
    private var retryDelay: TimeInterval = 1.0 // 初始重试延迟时间（秒）
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConfig.API.timeout
        configuration.timeoutIntervalForResource = AppConfig.API.timeout
        configuration.waitsForConnectivity = AppConfig.API.waitsForConnectivity
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: configuration)
        cache.countLimit = AppConfig.API.defaultNumberOfResults
    }
    
    func getRandomRecipe(category: String? = nil) -> AnyPublisher<Recipe, APIError> {
        fetchRandomRecipe(category: category)
            .catch { [weak self] error -> AnyPublisher<Recipe, APIError> in
                guard let self = self else {
                    return Fail(error: APIError.unknown(NSError(domain: "RecipeAPIService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Service was deallocated"]))).eraseToAnyPublisher()
                }
                
                if self.retryAttempt < self.maxRetries {
                    self.retryAttempt += 1
                    print("Retrying API call (attempt \(self.retryAttempt)/\(self.maxRetries))...")
                    
                    // 使用指数退避策略
                    let delay = self.retryDelay * pow(2.0, Double(self.retryAttempt - 1))
                    self.retryDelay = min(delay, 10.0) // 最大延迟10秒
                    
                    return Just(())
                        .delay(for: .seconds(delay), scheduler: DispatchQueue.global())
                        .flatMap { _ in self.getRandomRecipe(category: category) }
                        .eraseToAnyPublisher()
                }
                
                self.retryAttempt = 0
                self.retryDelay = 1.0
                if let apiError = error as? APIError {
                    return Fail(error: apiError).eraseToAnyPublisher()
                } else {
                    return Fail(error: APIError.unknown(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchRandomRecipe(category: String? = nil) -> AnyPublisher<Recipe, APIError> {
        var components = URLComponents(string: "\(AppConfig.API.baseURL)/random.php")!
        var isCategoryFilter = false
        
        if let category = category, category != "all" {
            components = URLComponents(string: "\(AppConfig.API.baseURL)/filter.php")!
            components.queryItems = [URLQueryItem(name: "c", value: category)]
            isCategoryFilter = true
        } else {
            components.queryItems = [URLQueryItem(name: "t", value: "\(Date().timeIntervalSince1970)")]
        }
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        let publisher = session.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { APIError.networkError($0) }
        
        if isCategoryFilter {
            return publisher
                .decode(type: CategoryMealResponse.self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if let decodingError = error as? DecodingError {
                        return .decodingError(decodingError)
                    }
                    return error as? APIError ?? .unknown(error)
                }
                .flatMap { response -> AnyPublisher<Recipe, APIError> in
                    guard let meals = response.meals, !meals.isEmpty else {
                        return Fail(error: APIError.noData).eraseToAnyPublisher()
                    }
                    let randomIndex = Int.random(in: 0..<meals.count)
                    let mealId = meals[randomIndex].idMeal
                    return self.fetchRecipeDetails(id: mealId)
                }
                .eraseToAnyPublisher()
        } else {
            return publisher
                .decode(type: MealResponse.self, decoder: JSONDecoder())
                .mapError { error -> APIError in
                    if let decodingError = error as? DecodingError {
                        return .decodingError(decodingError)
                    }
                    return error as? APIError ?? .unknown(error)
                }
                .flatMap { response -> AnyPublisher<Recipe, APIError> in
                    guard let meal = response.meals.first else {
                        return Fail(error: APIError.noData).eraseToAnyPublisher()
                    }
                    return Just(meal.asRecipe())
                        .setFailureType(to: APIError.self)
                        .eraseToAnyPublisher()
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func fetchRecipeDetails(id: String) -> AnyPublisher<Recipe, APIError> {
        var components = URLComponents(string: "\(AppConfig.API.baseURL)/lookup.php")!
        components.queryItems = [URLQueryItem(name: "i", value: id)]
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    print("API Error: HTTP \(httpResponse.statusCode)")
                    throw APIError.httpError(httpResponse.statusCode)
                }
                
                guard !data.isEmpty else {
                    print("API Error: Empty response data")
                    throw APIError.noData
                }
                
                return data
            }
            .decode(type: MealResponse.self, decoder: JSONDecoder())
            .tryMap { response -> Recipe in
                guard let meal = response.meals.first else {
                    print("API Error: No meal found in response")
                    throw APIError.noData
                }
                return meal.asRecipe()
            }
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                print("API Error: \(error.localizedDescription)")
                return APIError.unknown(error)
            }
            .eraseToAnyPublisher()
    }
    
    func clearCache() {
        cache.removeAllObjects()
        loadedRecipes.removeAll()
    }
}
