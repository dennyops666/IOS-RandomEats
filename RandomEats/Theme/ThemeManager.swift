import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "theme")
            setAppearance(darkMode: isDarkMode)
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "theme")
        setAppearance(darkMode: isDarkMode)
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    private func setAppearance(darkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = darkMode ? .dark : .light
            }
        }
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
        Color.blue
    }
    
    var cardBackgroundColor: Color {
        isDarkMode ? Color(UIColor.systemGray6) : Color.white
    }
    
    var separatorColor: Color {
        isDarkMode ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
}
