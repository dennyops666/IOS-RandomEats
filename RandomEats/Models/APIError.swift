import Foundation

enum APIError: Error {
    case decodingError(DecodingError)
    case networkError(Error)
    case invalidURL
    case noData
    case quotaExceeded
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .decodingError(let error):
            return "数据解析错误：\(error.localizedDescription)"
        case .networkError(let error):
            if (error as NSError).domain == "HTTP" && (error as NSError).code == 402 {
                return "API 配额已用完，请稍后再试"
            }
            return "网络错误：\(error.localizedDescription)"
        case .invalidURL:
            return "无效的URL地址"
        case .noData:
            return "没有找到数据"
        case .quotaExceeded:
            return "API 配额已用完，请稍后再试"
        case .unknown:
            return "未知错误"
        }
    }
}
