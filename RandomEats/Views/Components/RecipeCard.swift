import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 使用占位图片
            if let image = UIImage(named: recipe.image) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .foregroundColor(.gray)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            Text(recipe.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(recipe.category)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("食材:")
                    .font(.headline)
                
                ForEach(recipe.ingredients, id: \.name) { ingredient in
                    Text("• \(ingredient.name): \(ingredient.amount)")
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 4)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
