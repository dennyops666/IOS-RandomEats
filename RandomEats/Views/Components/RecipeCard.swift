import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AsyncImage(url: URL(string: recipe.image)) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.5)
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                if let category = recipe.category {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if !recipe.ingredients.isEmpty {
                    Text("食材:")
                        .font(.headline)
                        .padding(.top, 4)
                    
                    ForEach(recipe.ingredients.prefix(3), id: \.name) { ingredient in
                        Text("• \(ingredient.name): \(ingredient.amount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if recipe.ingredients.count > 3 {
                        Text("...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
