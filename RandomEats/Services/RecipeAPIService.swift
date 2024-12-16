import Foundation
import Combine

class RecipeAPIService {
    private let session: URLSession
    private let cache = NSCache<NSString, AnyObject>()
    private let cacheKey = "randomRecipes"
    private var loadedRecipes: [String: [Recipe]] = [:] // 按类别存储菜谱
    private var retryAttempt = 0
    private let maxRetries = AppConfig.API.maxRetries
    
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
        return fetchRandomRecipe(category: category)
            .retry(maxRetries)
            .catch { error -> AnyPublisher<Recipe, APIError> in
                if self.retryAttempt < self.maxRetries {
                    self.retryAttempt += 1
                    return self.getRandomRecipe(category: category)
                }
                self.retryAttempt = 0
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchRandomRecipe(category: String? = nil) -> AnyPublisher<Recipe, APIError> {
        var components = URLComponents(string: "\(AppConfig.API.baseURL)/random.php")!
        
        // 如果指定了类别，使用 filter.php 端点
        if let category = category, category != "all" {
            components = URLComponents(string: "\(AppConfig.API.baseURL)/filter.php")!
            components.queryItems = [URLQueryItem(name: "c", value: category)]
        } else {
            // 添加随机参数来避免缓存
            components.queryItems = [URLQueryItem(name: "t", value: "\(Date().timeIntervalSince1970)")]
        }
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        return session.dataTaskPublisher(for: request)
            .mapError { _ in APIError.networkError(NSError(domain: "NetworkError", code: -1009)) }
            .flatMap { [weak self] data, response -> AnyPublisher<Recipe, APIError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: APIError.networkError(NSError(domain: "InvalidResponse", code: -1))).eraseToAnyPublisher()
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    return Fail(error: APIError.networkError(NSError(domain: "HTTPError", code: httpResponse.statusCode))).eraseToAnyPublisher()
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MealDBResponse.self, from: data)
                    
                    guard let meals = response.meals, !meals.isEmpty else {
                        return Fail(error: APIError.noData).eraseToAnyPublisher()
                    }
                    
                    // 随机选择一个菜谱
                    let randomIndex = Int.random(in: 0..<meals.count)
                    let recipe = meals[randomIndex].asRecipe()
                    
                    // 如果是按类别筛选，需要获取完整的菜谱详情
                    if category != nil && category != "all" {
                        return self?.fetchRecipeDetails(id: recipe.id) ?? 
                            Fail(error: APIError.noData).eraseToAnyPublisher()
                    }
                    
                    return Just(recipe)
                        .setFailureType(to: APIError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: APIError.decodingError(error as? DecodingError ?? DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: error.localizedDescription)))).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchRecipeDetails(id: String) -> AnyPublisher<Recipe, APIError> {
        var components = URLComponents(string: "\(AppConfig.API.baseURL)/lookup.php")!
        components.queryItems = [URLQueryItem(name: "i", value: id)]
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .mapError { _ in APIError.networkError(NSError(domain: "NetworkError", code: -1009)) }
            .flatMap { data, response -> AnyPublisher<Recipe, APIError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: APIError.networkError(NSError(domain: "InvalidResponse", code: -1))).eraseToAnyPublisher()
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    return Fail(error: APIError.networkError(NSError(domain: "HTTPError", code: httpResponse.statusCode))).eraseToAnyPublisher()
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MealDBResponse.self, from: data)
                    
                    guard let meals = response.meals, !meals.isEmpty else {
                        return Fail(error: APIError.noData).eraseToAnyPublisher()
                    }
                    
                    let recipe = meals[0].asRecipe()
                    return Just(recipe)
                        .setFailureType(to: APIError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: APIError.decodingError(error as? DecodingError ?? DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: error.localizedDescription)))).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    func clearCache() {
        cache.removeAllObjects()
        loadedRecipes.removeAll()
    }
}
