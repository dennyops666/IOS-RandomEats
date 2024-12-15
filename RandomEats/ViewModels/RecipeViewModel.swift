import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var currentRecipe: Recipe?
    @Published var recentlyShownRecipes: Set<UUID> = []
    private let maxRecentRecipes = 5
    
    init() {
        loadRecipes()
    }
    
    private func loadRecipes() {
        guard let url = Bundle.main.url(forResource: "recipes", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error: Cannot find or load recipes.json")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(RecipeResponse.self, from: data)
            self.recipes = response.recipes
        } catch {
            print("Error decoding recipes: \(error)")
        }
    }
    
    func generateRandomRecipe(category: String? = nil) {
        let filteredRecipes: [Recipe]
        if let category = category {
            filteredRecipes = recipes.filter { $0.category == category }
        } else {
            filteredRecipes = recipes
        }
        
        guard !filteredRecipes.isEmpty else {
            print("No recipes available for category: \(category ?? "all")")
            return
        }
        
        // Filter out recently shown recipes unless we have no choice
        var availableRecipes = filteredRecipes.filter { !recentlyShownRecipes.contains($0.id) }
        if availableRecipes.isEmpty {
            availableRecipes = filteredRecipes
            recentlyShownRecipes.removeAll()
        }
        
        if let recipe = availableRecipes.randomElement() {
            currentRecipe = recipe
            recentlyShownRecipes.insert(recipe.id)
            
            // Remove oldest recipe if we exceed maxRecentRecipes
            if recentlyShownRecipes.count > maxRecentRecipes {
                recentlyShownRecipes.remove(recentlyShownRecipes.first!)
            }
        }
    }
    
    func getAvailableCategories() -> [String] {
        Array(Set(recipes.map { $0.category })).sorted()
    }
}
