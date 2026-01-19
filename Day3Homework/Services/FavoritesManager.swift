//
//  FavoritesManager.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/31.
//

import Foundation

//お気に入りを保存している　ここでUseDefaultsを書いている

@MainActor
class FavoritesManager: ObservableObject{
    //お気に入り映画リスト（変更すると画面が更新するようにしている）
    @Published var favoriteMovies: [Movie] = []
    
    private let key = "favotite_movies"//保存するキーの設定
    
    //UserDefaultをプロパティとして保持（テストを書くためここをプロパティにする必要がある）
    private let userDefaults: UserDefaults
    //initで外部から注入できるようにする
    //これをすることでUsedafaultを本番用と、テスト用で使い分けてデータ保存できる
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()

    }
    
    func isFavorite(_ movie: Movie) -> Bool {
        return favoriteMovies.contains(where: { savedMovie in
            return savedMovie.id == movie.id
        })
    }
    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFavorite(movie)
        } else {
            addFavorite(movie)
        }
    }
    
    private func addFavorite(_ movie: Movie) {
        favoriteMovies.append(movie)
        saveFavorites()
    }
    
    // 修正箇所2: ここも $0 をやめて明記
    private func removeFavorite(_ movie: Movie) {
        favoriteMovies.removeAll(where: { savedMovie in
            return savedMovie.id == movie.id
        })
        saveFavorites()
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteMovies) {
            userDefaults.set(encoded, forKey: key)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Movie].self, from: data) {
            self.favoriteMovies = decoded
        }
    }
}
