import XCTest
@testable import RandomEats

final class FavoriteManagerTests: XCTestCase {
    var favoriteManager: FavoriteManager!
    var testRecipe: Recipe!
    
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
        favoriteManager = nil
        testRecipe = nil
        super.tearDown()
    }
    
    // 测试用例 1：测试添加收藏
    func testAddFavorite() {
        favoriteManager.addFavorite(testRecipe)
        XCTAssertTrue(favoriteManager.isFavorite(testRecipe), "菜谱应该被成功添加到收藏")
        XCTAssertEqual(favoriteManager.favorites.count, 1, "收藏列表应该只有一个菜谱")
    }
    
    // 测试用例 2：测试移除收藏
    func testRemoveFavorite() {
        // 先添加收藏
        favoriteManager.addFavorite(testRecipe)
        XCTAssertTrue(favoriteManager.isFavorite(testRecipe), "菜谱应该被成功添加到收藏")
        
        // 移除收藏
        if let favorite = favoriteManager.favorites.first {
            favoriteManager.removeFavorite(favorite)
            XCTAssertFalse(favoriteManager.isFavorite(testRecipe), "菜谱应该被成功从收藏中移除")
            XCTAssertTrue(favoriteManager.favorites.isEmpty, "收藏列表应该为空")
        }
    }
    
    // 测试用例 3：测试重复添加
    func testDuplicateAdd() {
        favoriteManager.addFavorite(testRecipe)
        let initialCount = favoriteManager.favorites.count
        
        // 再次添加相同菜谱
        favoriteManager.addFavorite(testRecipe)
        XCTAssertEqual(favoriteManager.favorites.count, initialCount, "不应该重复添加相同的菜谱")
    }
}
