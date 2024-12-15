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
    
    var body: some Scene {
        WindowGroup {
            ContentView(recipeViewModel: recipeViewModel, favoriteManager: favoriteManager)
        }
    }
}
