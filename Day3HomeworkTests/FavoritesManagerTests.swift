//
//  FavoritesManagerTests.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2026/01/08.
//

//FavotiteManagerのテストコードです

import Testing
import Foundation
@testable import Day3Homework

@MainActor
struct FavoritesManagerTests {
    var manager: FavoritesManager
    var testDefaults: UserDefaults
    //テスト用の隔離されてたUserDafaultを作る
    //suiteNameを指定すると、本番データとは別の場所に保存されます（サンドボックス化）
    init(){
        let suiteName = "TestFavoritesBucket"
        testDefaults = UserDefaults(suiteName: suiteName)!
        
        //テストのために中身を空っぽにする
        testDefaults.removePersistentDomain(forName: suiteName)
        
        //テスト用のUserDefaultsを渡してManagerを作る
        //Mainactorがないとmanager分けれない
        manager = FavoritesManager(userDefaults: testDefaults)
        
    }
    @Test("追加: リストに追加され、UserDefaultsに保存されること",arguments: [
        Movie(
            id: 1,
            title: "テスト用映画",
            overview: "面白い映画です",
            posterPath: "/test.jpg",
            releaseDate:"December",
            voteAverage: 8.5
        )
    ])
    func addFavorite(movie:Movie) async{
        //何も追加されていないので追加される
        manager.toggleFavorite(movie)
        //追加されているのかのチェック
        #expect(manager.isFavorite(movie) == true)
        //追加されていればfavoriteの数が１になっているはず
        #expect(manager.favoriteMovies.count == 1)
        
        //本当に保存されているのかを確認
        //新しくマネージャーを立てても同じUserdafoultならば同じ場所を見にいくという考えからこのマネージャーでたてて追加されているかのチェックと、個数を確認することで保存されているのかがわかる
        let newManager = FavoritesManager(userDefaults: testDefaults)
        //新しくたてたマネージャーでも保存が確認できるかのテスト
        #expect(newManager.isFavorite(movie) == true)
        #expect(newManager.favoriteMovies.count == 1)
    }
    @Test("削除: リストから削除され、UserDefaultsからも削除されること",arguments: [
        Movie(
            id: 1,
            title: "テスト用映画",
            overview: "面白い映画ですa",
            posterPath: "/test.jpg",
            releaseDate:"December",
            voteAverage: 8.5
        )
    ])
    func removeFavorite(movie: Movie) async{
        //お気に入りに追加しておく
        manager.toggleFavorite(movie)
        //2回やることで取り消しができるのでやる
        manager.toggleFavorite(movie)
        
        //メモリを見る追加してその後に削除することでその値が保存していない状態に戻っているか見るため
        #expect(manager.isFavorite(movie) == false)
        #expect(manager.favoriteMovies.count == 0)
        
        let newManager = FavoritesManager(userDefaults: testDefaults)
        //ここで何も入っていないことが確認できれば削除できたと断定できる
        #expect(newManager.favoriteMovies.isEmpty)
        
    }
    
}

