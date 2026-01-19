//
//  MovieListViewModelTests.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2026/01/07.
//

import Testing
import Foundation
@testable import Day3Homework

@MainActor
struct MovieListViewModelTests {
    //今回のテスト対象
    var viewmodel: MovieListViewModel
    //依存するモック
    var mockService: MockMovieService
    
    //initはテストケースごとに呼ばれる
    init(){
        self.mockService = MockMovieService()
        //ここで本物ではなくモックを渡す
        //Viewmodelのプロトコルに準拠している関数を、モック用のものを注入する
        self.viewmodel = MovieListViewModel(service:mockService)
    }
    @Test("映画の情報を追加することに成功",arguments:[
        Movie(
            id: 1,
            title: "テスト用映画",
            overview: "面白い映画です",
            posterPath: "/test.jpg",
            releaseDate:"December",
            voteAverage: 8.5
        )]
    )
    func loadMoviesSuccess(movie:Movie) async{
        //モックの中にあるresult型の.succuesにargumentを投げている
        mockService.resultToReturn  = .success([movie])
        //viewmodelがMovieを読み込むのを待つ
        await viewmodel.loadMovies()
        //ここで
        #expect(viewmodel.movies.first?.title == movie.title)
    }
    //これmovie2
    @Test("追加読み込みトリガー: 指定した映画がリストの最後ならAPIが呼ばれる", arguments:[
        Movie(
            id: 1,
            title: "テスト用映画",
            overview: "面白い映画です",
            posterPath: "/test.jpg",
            releaseDate:"December",
            voteAverage: 8.5
        )
    ])
    func loadMoreTrigger(targetMovie: Movie) async {
        //テストで渡ってきた `targetMovie` を「現在のリストの唯一のデータ」としてセットするそうすることで最後の要素としてテストできる
        mockService.resultToReturn = .success([targetMovie])
        //viewmodelにデータを読み込ませる部分
        await viewmodel.loadMovies()
        //初期ロードで一回呼ばれてしまうために初期化ここ大事！
        mockService.fetchPopularMoviesCallCount = 0
        
        // 次のページ用のダミーデータをセット (成功するようにしておく)
        mockService.resultToReturn = .success([])
        //viewmodelのloadMoreContentにtargetMovieを送る
        await viewmodel.loadMoreContent(currentItem: targetMovie)
        //targetMovieは強制的に最後にしているから再度読み込みされてカウントが１回増えると正解つまり１になれば成功
        #expect(mockService.fetchPopularMoviesCallCount == 1)
    }
    @Test("追加読み込み以外でAPIが呼ばれていないことを確かめる")
    func loadMoreGuard() async {
        let movie1 =
        Movie(
            id: 1,
            title: "テスト用映画",
            overview: "面白い映画です",
            posterPath: "/test.jpg",
            releaseDate:"December",
            voteAverage: 8.5
        )
        let movie2 =
        Movie(
            id: 2,
            title: "テスト用2映画",
            overview: "面白い映画2です",
            posterPath: "/test.jpg",
            releaseDate:"December 2",
            voteAverage: 10.0
        )
        //映画を２こセットする
        mockService.resultToReturn = .success([movie1, movie2])
        //2この映画をロードさせる
        await viewmodel.loadMovies()
        //API通信は０であると強制的に初期化する
        mockService.fetchPopularMoviesCallCount = 0
        //最後の要素ではないmovie1を得たとす
        await viewmodel.loadMoreContent(currentItem:movie1)
        
        //最後ではないので０が出ると成功（APIが映画を読み込む以外のタイミングで再読み込みされていないかどうか確認）
        #expect(mockService.fetchPopularMoviesCallCount == 0)
    }
}

