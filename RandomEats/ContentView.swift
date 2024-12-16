//
//  ContentView.swift
//  RandomEats
//
//  Created by Django on 12/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var recipeViewModel: RecipeViewModel
    @EnvironmentObject private var favoriteManager: FavoriteManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if let recipe = recipeViewModel.currentRecipe {
                        ScrollView {
                            RecipeDetailView(recipe: recipe)
                                .padding()
                        }
                    } else {
                        Text("No recipe loaded")
                            .foregroundColor(themeManager.primaryTextColor)
                    }
                    
                    Button(action: {
                        recipeViewModel.generateRandomRecipe()
                    }) {
                        Text("Generate Random Recipe")
                            .foregroundColor(.white)
                            .padding()
                            .background(themeManager.accentColor)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationTitle("Random Eats")
            .navigationBarItems(
                leading: NavigationLink(destination: FavoriteListView()) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(themeManager.accentColor)
                },
                trailing: NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                        .foregroundColor(themeManager.accentColor)
                }
            )
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
        .environmentObject(RecipeViewModel())
        .environmentObject(FavoriteManager())
}
