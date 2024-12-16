import Foundation

enum AppConfig {
    static let version = "1.1.0"
    
    enum UserDefaults {
        static let themeKey = "app_theme_isDarkMode"
        static let favoritesKey = "app_favorites"
    }
    
    enum API {
        static let baseURL = "https://www.themealdb.com/api/json/v1/1"
        static let randomEndpoint = "/random.php"
        static let searchEndpoint = "/search.php"
        static let lookupEndpoint = "/lookup.php"
        static let categoriesEndpoint = "/categories.php"
    }
}
