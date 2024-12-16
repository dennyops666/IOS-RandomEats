import Foundation

enum APIError: Error {
    case decodingError(DecodingError)
    case networkError(Error)
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case noData
    case quotaExceeded
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .decodingError(let error):
            return "数据解析错误：\(error.localizedDescription)"
        case .networkError(let error):
            return "网络错误：\(error.localizedDescription)"
        case .invalidURL:
            return "无效的URL地址"
        case .invalidResponse:
            return "无效的服务器响应"
        case .httpError(let code):
            return "HTTP错误：\(code)"
        case .noData:
            return "没有数据返回"
        case .quotaExceeded:
            return "API 配额已用完，请稍后再试"
        case .unknown(let error):
            return "未知错误：\(error.localizedDescription)"
        }
    }
}
