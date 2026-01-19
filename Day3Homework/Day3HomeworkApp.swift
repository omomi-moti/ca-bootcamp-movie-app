import SwiftUI

@main
struct Day3HomeworkApp: App {
    // 1. ここで「親玉」を1つだけ生成します（所有権を持つ）
        // @StateObject は「このViewが生きている間（＝アプリ起動中）ずっと保持する」という意味です
    @StateObject private var favoritesManager = FavoritesManager()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(favoritesManager)
        }
    }
}
