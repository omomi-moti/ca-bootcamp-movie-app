//
//  Untitled.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//

import Foundation
//Mainactorがあることで表の処理(Viewで逐一変更する部分)と、裏の処理(並行処理で行う部分)を分けて書く
//このクラスの変数を書き換えるときは、必ず『メインスレッド（表の処理）』でやることを保証する
@MainActor
class MovieListViewModel: ObservableObject {
    //Published properties Viewが監視するデータこのデータでViewの状態が変わる
    @Published var movies: [Movie] = [] //映画リスト
    @Published var isLoading: Bool = false //ロード中フラグ用
    @Published var errorMessage: String? = nil //なんかあったらアラート出すよう
    
    //内部用変数(監視対象ではない)
    private let service: MovieServiceProtocol
    private var currentPage: Int = 1
    private var isFechingMore: Bool = false //追加読み込み中かどうか
    
    // テスト時に「偽物のService」を渡せるように設計する
    //プロトコルを作ったおかげで偽物のServiesを作れるようになっている
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    //初期ロードの時のみに呼ばれる
    //これがあることでAPIが保持するページの数字を合わせることで画面遷移などで映画の取得が変わった時などにページ数から正しく画面に表示できる
    func loadMovies() async {
        guard !isLoading else { return } //ロードずみなら何もしない
        
        isLoading = true
        errorMessage = nil
        currentPage = 1 //ページを１に戻る
        
        do {
            // Serviceを使ってデータを取得
            let newMovies = try await service.fetchPopularMovies(page: currentPage)
            self.movies = newMovies
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    //無限読み取り（無限スクロール）
    //リストの項目が表示されるときに呼ばれる
    func loadMoreContent(currentItem item: Movie) async{
        //リストの最後の要素じゃなければ何もしない
        let thresholdIndex = self.movies.index(self.movies.endIndex, offsetBy: -1)
        
        let index = self.movies.firstIndex(where: { movie in
            return movie.id == item.id
        })
        //最後の要素でなければ、ここで終了
        if index != thresholdIndex { return }
        
        //読み込み中なら何もしない
        guard !isFechingMore, !isLoading else { return }
        isFechingMore = true // 読み込み中のフラグを上げる
        let nextPage = currentPage + 1
        
        do{
            //新しい映画の取得
            let newMovies = try await service.fetchPopularMovies(page: nextPage)
            
            //filterで条件に合ったものだけに絞る
            let uniqueMovies = newMovies.filter{newMovie in
                
                let isAlradyExist = self.movies.contains(where:{ existingMovie in
                    existingMovie.id == newMovie.id
                    
                })
                //newmovieがtrue(いる)なのかfalse(いない)で返している
                //ここ反転しているのはチェックしているのは重複しているかどうかだから
                return !isAlradyExist
            }
            //uniqueMoviesを追加している
            self.movies.append(contentsOf: uniqueMovies)
            //いるページを次のページに更新する
            self.currentPage = nextPage
            
        }
        catch{
            print("追加読み込みエラー: \(error.localizedDescription)")
        }
        //読み込み終了のフラグ
        isFechingMore = false
    }
    
}

