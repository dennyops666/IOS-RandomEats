//
//  ContentView.swift
//  RandomEats
//
//  Created by Django on 12/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var favoriteManager = FavoriteManager()
    @State private var selectedTab = 0
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("首页")
            }
            .tag(0)
            
            NavigationView {
                FavoriteListView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("收藏")
            }
            .tag(1)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
            .tag(2)
        }
        .environmentObject(recipeViewModel)
        .environmentObject(favoriteManager)
    }
}

// 主页视图包装器
struct HomeView: View {
    var body: some View {
        RecipeHomeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let favoriteManager = FavoriteManager()
        let themeManager = ThemeManager()
        let recipeViewModel = RecipeViewModel()
        
        ContentView()
            .environmentObject(favoriteManager)
            .environmentObject(themeManager)
            .environmentObject(recipeViewModel)
    }
}
