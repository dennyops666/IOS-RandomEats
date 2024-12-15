import Foundation

struct Recipe: Identifiable, Codable {
    var id: UUID = UUID()
    let name: String
    let category: String
    let ingredients: [Ingredient]
    let steps: [String]
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case name, category, ingredients, steps, image
    }
}

struct Ingredient: Codable {
    let name: String
    let amount: String
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
