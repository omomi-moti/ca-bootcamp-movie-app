
//
//  .swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//

import Foundation

//Identifiable: SwiftUiのList,ForEachで一意識別するために必要
//codable: JSONデータをswiftの構造体にしてくれる
//Sendable: 並行処置で安全にデータを渡すために必要

struct Movie: Identifiable,Codable, Equatable,Sendable{
    let id:Int
    let title: String
    let overview: String
    let posterPath: String?//画像がない場合のためにオプショナル型で宣言
    let releaseDate: String? //ここはDateじゃなくてもいいのか？
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey { //スネークケースをキャメルケースに変換する
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    var posterImageURL:URL?{ //画像のフルパスを生成するプロパティ
        guard let path = posterPath else { return nil }
        return URL(string:"https://image.tmdb.org/t/p/w500\(path)")
    }
}
