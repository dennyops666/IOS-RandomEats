import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @ObservedObject var favoriteManager: FavoriteManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 标题部分
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(recipe.category)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // 图片部分
                if let image = UIImage(named: recipe.image) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .foregroundColor(.gray)
                        .background(Color(.systemGray6))
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
                .padding(.horizontal)
                
                // 步骤部分
                VStack(alignment: .leading, spacing: 12) {
                    Text("制作步骤")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            Text(step)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if favoriteManager.isFavorite(recipe) {
                        favoriteManager.removeFavoriteByRecipe(recipe)
                    } else {
                        favoriteManager.addFavorite(recipe)
                    }
                }) {
                    Image(systemName: favoriteManager.isFavorite(recipe) ? "heart.fill" : "heart")
                        .foregroundColor(favoriteManager.isFavorite(recipe) ? .red : .gray)
                }
            }
        }
    }
}
