//
//  RandomEatsApp.swift
//  RandomEats
//
//  Created by Django on 12/15/24.
//

import SwiftUI

@main
struct RandomEatsApp: App {
    @StateObject private var recipeViewModel = RecipeViewModel()
    @StateObject private var favoriteManager = FavoriteManager()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(recipeViewModel)
                .environmentObject(favoriteManager)
                .environmentObject(themeManager)
        }
    }
}
