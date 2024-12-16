import SwiftUI

struct ThemeToggleButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            withAnimation {
                themeManager.toggleTheme()
            }
        }) {
            Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 20))
                .foregroundColor(themeManager.isDarkMode ? .yellow : .purple)
                .padding(8)
                .background(
                    Circle()
                        .fill(themeManager.isDarkMode ? Color.black : Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                )
                .overlay(
                    Circle()
                        .stroke(themeManager.isDarkMode ? Color.yellow.opacity(0.5) : Color.purple.opacity(0.5), lineWidth: 2)
                )
        }
    }
}
