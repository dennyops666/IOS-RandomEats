//
//  RandomEatsApp.swift
//  RandomEats
//
//  Created by Django on 12/15/24.
//

import SwiftUI

@main
struct RandomEatsApp: App {
    @StateObject private var favoriteManager = FavoriteManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var recipeViewModel = RecipeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoriteManager)
                .environmentObject(themeManager)
                .environmentObject(recipeViewModel)
                .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}
