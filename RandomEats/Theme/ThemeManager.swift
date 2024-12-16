import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    // 主题颜色
    var backgroundColor: Color {
        isDarkMode ? Color.black : Color.white
    }
    
    var primaryTextColor: Color {
        isDarkMode ? Color.white : Color.black
    }
    
    var secondaryTextColor: Color {
        isDarkMode ? Color.gray : Color.gray
    }
    
    var accentColor: Color {
        isDarkMode ? Color.orange : Color.orange
    }
    
    var cardBackgroundColor: Color {
        isDarkMode ? Color(UIColor.systemGray6) : Color.white
    }
    
    var separatorColor: Color {
        isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
}
