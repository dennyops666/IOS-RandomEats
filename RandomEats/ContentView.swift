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
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        TabView {
            NavigationView {
                RecipeHomeView()
                    .navigationBarTitle("随机菜谱", displayMode: .inline)
            }
            .tabItem {
                Label("首页", systemImage: "house")
            }
            
            NavigationView {
                FavoriteView()
                    .navigationBarTitle("收藏", displayMode: .inline)
            }
            .tabItem {
                Label("收藏", systemImage: "heart")
            }
            
            NavigationView {
                SettingsView()
                    .navigationBarTitle("设置", displayMode: .inline)
            }
            .tabItem {
                Label("设置", systemImage: "gear")
            }
        }
        .environmentObject(recipeViewModel)
        .environmentObject(favoriteManager)
        .environmentObject(themeManager)
    }
}

// 主页视图包装器
struct HomeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
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
