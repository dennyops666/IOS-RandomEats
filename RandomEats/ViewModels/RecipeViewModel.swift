import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    private let apiService = RecipeAPIService()
    
    @Published var currentRecipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingCategorySelection = false
    @Published var selectedCategory: String = "all"
    
    private var cancellables = Set<AnyCancellable>()
    
    // 分类名称映射
    let categoryMapping: [(apiName: String, displayName: String)] = [
        ("all", "全部分类"),
        ("Beef", "牛肉"),
        ("Chicken", "鸡肉"),
        ("Dessert", "甜点"),
        ("Lamb", "羊肉"),
        ("Miscellaneous", "其他"),
        ("Pasta", "意面"),
        ("Pork", "猪肉"),
        ("Seafood", "海鲜"),
        ("Side", "配菜"),
        ("Starter", "开胃菜"),
        ("Vegan", "纯素"),
        ("Vegetarian", "素食")
    ]
    
    // 获取所有可用的食物分类
    var getAvailableCategories: [(apiName: String, displayName: String)] {
        return categoryMapping
    }
    
    // 获取分类的显示名称
    func getDisplayName(for apiName: String) -> String {
        if apiName.isEmpty || apiName == "all" {
            return "全部分类"
        }
        return categoryMapping.first { $0.apiName == apiName }?.displayName ?? apiName
    }
    
    // 获取当前分类的显示名称
    func getCurrentCategoryDisplayName() -> String {
        if let currentRecipe = currentRecipe, let category = currentRecipe.category {
            return getDisplayName(for: category)
        }
        return getDisplayName(for: selectedCategory)
    }
    
    func generateRandomRecipe(category: String? = nil) {
        isLoading = true
        errorMessage = nil
        currentRecipe = nil
        
        let categoryToUse = category ?? selectedCategory
        let apiCategory = categoryToUse == "all" ? nil : categoryToUse
        
        apiService.getRandomRecipe(category: apiCategory)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("API Error: \(error)")
                    switch error {
                    case .decodingError(let decodingError):
                        print("Decoding Error Details: \(decodingError)")
                        self?.errorMessage = "解析数据时出错：\(decodingError.localizedDescription)"
                    case .networkError(let networkError):
                        print("Network Error Details: \(networkError)")
                        self?.errorMessage = "网络连接出错：\(networkError.localizedDescription)"
                    case .invalidURL:
                        self?.errorMessage = "无效的请求地址"
                    case .invalidResponse:
                        self?.errorMessage = "服务器响应无效"
                    case .httpError(let code):
                        self?.errorMessage = "HTTP错误：\(code)"
                    case .noData:
                        self?.errorMessage = "未找到相关菜谱"
                    case .quotaExceeded:
                        self?.errorMessage = "API 配额已用完，请稍后再试"
                    case .unknown(let error):
                        self?.errorMessage = "未知错误：\(error.localizedDescription)"
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] recipe in
                print("Received Recipe: \(recipe)")
                self?.currentRecipe = recipe
            }
            .store(in: &cancellables)
    }
    
    func clearRecipe() {
        currentRecipe = nil
        errorMessage = nil
    }
}
