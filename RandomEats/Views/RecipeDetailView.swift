import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var favoriteManager: FavoriteManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 使用占位图片
                Image(recipe.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()
                    .overlay(
                        Group {
                            if UIImage(named: recipe.image) == nil {
                                Image("recipe_placeholder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                    )
                
                // 标题部分
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(recipe.category)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // 食材部分
                VStack(alignment: .leading, spacing: 12) {
                    Text("食材")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(recipe.ingredients, id: \.name) { ingredient in
                        HStack {
                            Text("•")
                            Text(ingredient.name)
                                .fontWeight(.medium)
                            Spacer()
                            Text(ingredient.amount)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // 步骤部分
                VStack(alignment: .leading, spacing: 12) {
                    Text("制作步骤")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                                .frame(width: 25, alignment: .leading)
                            Text(step)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: favoriteButton)
    }
    
    private var favoriteButton: some View {
        Button(action: {
            if favoriteManager.isFavorite(recipe) {
                if let favorite = favoriteManager.favorites.first(where: { $0.recipe.id == recipe.id }) {
                    favoriteManager.removeFavorite(favorite)
                }
            } else {
                favoriteManager.addFavorite(recipe)
            }
        }) {
            Image(systemName: favoriteManager.isFavorite(recipe) ? "heart.fill" : "heart")
                .foregroundColor(favoriteManager.isFavorite(recipe) ? .red : .gray)
        }
    }
}
