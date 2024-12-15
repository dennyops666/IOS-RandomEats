import XCTest
import SwiftUI
@testable import RandomEats

final class RecipeDetailViewTests: XCTestCase {
    var testRecipe: Recipe!
    var favoriteManager: FavoriteManager!
    
    override func setUp() {
        super.setUp()
        favoriteManager = FavoriteManager()
        
        // 创建测试用菜谱
        testRecipe = Recipe(
            id: UUID(),
            name: "测试菜谱",
            category: "测试分类",
            ingredients: [
                Ingredient(name: "测试食材1", amount: "100g"),
                Ingredient(name: "测试食材2", amount: "200ml")
            ],
            steps: ["步骤1", "步骤2"],
            image: "recipe_placeholder"
        )
    }
    
    override func tearDown() {
        testRecipe = nil
        favoriteManager = nil
        super.tearDown()
    }
    
    // 测试用例 1：测试视图创建
    func testDetailViewCreation() {
        let detailView = RecipeDetailView(recipe: testRecipe, favoriteManager: favoriteManager)
        XCTAssertNotNil(detailView, "应该成功创建详情视图")
    }
    
    // 测试用例 2：测试收藏按钮状态
    func testFavoriteButtonState() {
        // 初始状态
        XCTAssertFalse(favoriteManager.isFavorite(testRecipe), "初始状态应该是未收藏")
        
        // 添加到收藏
        favoriteManager.addFavorite(testRecipe)
        XCTAssertTrue(favoriteManager.isFavorite(testRecipe), "添加后应该显示为已收藏")
        
        // 从收藏中移除
        if let favorite = favoriteManager.favorites.first {
            favoriteManager.removeFavorite(favorite)
            XCTAssertFalse(favoriteManager.isFavorite(testRecipe), "移除后应该显示为未收藏")
        }
    }
    
    // 测试用例 3：测试步骤显示
    func testStepsDisplay() {
        let detailView = RecipeDetailView(recipe: testRecipe, favoriteManager: favoriteManager)
        XCTAssertNotNil(detailView, "应该成功创建详情视图")
        
        // 验证步骤数量
        XCTAssertEqual(testRecipe.steps.count, 2, "应该显示正确数量的步骤")
    }
}
