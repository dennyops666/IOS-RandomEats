import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Label("深色模式", systemImage: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                        Spacer()
                        Toggle("", isOn: $themeManager.isDarkMode)
                    }
                } header: {
                    Text("外观设置")
                }
                
                Section {
                    HStack {
                        Label("版本", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                } header: {
                    Text("关于")
                }
            }
            .navigationTitle("设置")
            .background(themeManager.backgroundColor)
            .foregroundColor(themeManager.primaryTextColor)
        }
    }
}
