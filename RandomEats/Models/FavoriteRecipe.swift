import Foundation

struct FavoriteRecipe: Codable, Identifiable {
    let id: UUID
    let recipe: Recipe
    let dateAdded: Date
    
    init(recipe: Recipe) {
        self.id = UUID()
        self.recipe = recipe
        self.dateAdded = Date()
    }
}
