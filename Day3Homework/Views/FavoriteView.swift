import SwiftUI

struct FavoriteView: View {
    //ここでバケツリレーで必要な部分にだけ情報を注入
    // 管理人を監視
    @EnvironmentObject var favoritesManager: FavoritesManager
    var body: some View {
        NavigationStack {
            Group {
                if favoritesManager.favoriteMovies.isEmpty {
                    // データがないときの表示 (Empty State)
                    // iOS17以降なら ContentUnavailableView が使えますが、汎用的にVStackで書きます
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("お気に入りはまだありません")
                            .font(.headline)
                        Text("気になった映画をリストに追加してみましょう")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // データがあるときのリスト表示
                    List {
                        ForEach(favoritesManager.favoriteMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                MovieRowView(movie: movie)
                            }
                        }
                        // スワイプで削除機能
                        .onDelete { indexSet in
                            for index in indexSet {
                                let movie = favoritesManager.favoriteMovies[index]
                                favoritesManager.toggleFavorite(movie)
                            }
                        }
                    }
                }
            }
            .navigationTitle("お気に入り")
        }
    }
}

#Preview("お気に入りがある時") {
    // 1. プレビュー用のマネージャーを作成
    let manager = FavoritesManager()
    
    // 2. プレビューで見たい仮のデータを注入（必要であれば）
    // ※ 実際は init でロードされますが、ここで movie を追加するロジックを書いてもOK
    
    return FavoriteView()
        .environmentObject(manager)
}

#Preview("お気に入りがない時") {
    // まっさらなインスタンスを渡すことで、空の状態を確認できる
    FavoriteView()
        .environmentObject(FavoritesManager())
}
