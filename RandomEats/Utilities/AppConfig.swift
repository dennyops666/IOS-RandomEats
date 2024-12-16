import Foundation

public enum AppConfig {
    public enum API {
        public static let baseURL = "https://www.themealdb.com/api/json/v1/1"
        public static let timeout: TimeInterval = 30
        public static let defaultNumberOfResults = 10
        public static let maxRetries = 3
        public static let waitsForConnectivity = true
    }
    
    public enum UserDefaults {
        public static let favoriteRecipesKey = "favoriteRecipes"
        public static let themeKey = "isDarkMode"
        public static let accentColorKey = "accentColor"
    }
}
