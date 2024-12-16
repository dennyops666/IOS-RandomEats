import Foundation
import Combine

class RecipeViewModel: ObservableObject {
    private let apiService = RecipeAPIService()
    
    @Published var currentRecipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingCategorySelection = false
    @Published var selectedCategory: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // 获取所有可用的食物分类
    var getAvailableCategories: [String] {
        return [
            "中餐",
            "西餐",
            "日料",
            "韩餐",
            "泰餐",
            "快餐",
            "甜点",
            "饮品",
            "其他"
        ]
    }
    
    func generateRandomRecipe(category: String? = nil) {
        isLoading = true
        errorMessage = nil
        currentRecipe = nil
        
        apiService.getRandomRecipe(category: category)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    print("API Error: \(error)")  // 添加调试日志
                    switch error {
                    case .decodingError(let decodingError):
                        print("Decoding Error Details: \(decodingError)")  // 添加详细解码错误信息
                        self?.errorMessage = "解析数据时出错：\(decodingError.localizedDescription)"
                    case .networkError(let networkError):
                        print("Network Error Details: \(networkError)")  // 添加网络错误详情
                        self?.errorMessage = "网络连接出错：\(networkError.localizedDescription)"
                    case .invalidURL:
                        self?.errorMessage = "无效的请求地址"
                    case .noData:
                        self?.errorMessage = "未找到相关菜谱，请重试"
                    case .quotaExceeded:
                        self?.errorMessage = "API 配额已用完，正在使用缓存数据"
                    case .unknown:
                        self?.errorMessage = "未知错误，请重试"
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] recipe in
                print("Received Recipe: \(recipe)")  // 添加成功接收数据的日志
                self?.currentRecipe = recipe
            }
            .store(in: &cancellables)
    }
    
    func clearRecipe() {
        currentRecipe = nil
        errorMessage = nil
    }
}
