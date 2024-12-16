import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var favoriteManager: FavoriteManager
    
    init() {}
    
    var body: some View {
        List {
            ForEach(favoriteManager.favorites.indices, id: \.self) { index in
                NavigationLink {
                    RecipeDetailView(recipe: favoriteManager.favorites[index])
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: favoriteManager.favorites[index].image)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(favoriteManager.favorites[index].name)
                                .font(.headline)
                            Text(favoriteManager.favorites[index].category ?? "未分类")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .onDelete(perform: deleteFavorite(at:))
        }
        .navigationTitle("收藏夹")
        .listStyle(InsetGroupedListStyle())
    }
    
    private func deleteFavorite(at offsets: IndexSet) {
        offsets.forEach { index in
            favoriteManager.removeFavoriteAtIndex(index)
        }
    }
}

struct FavoriteListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FavoriteListView()
                .environmentObject(FavoriteManager())
        }
    }
}
