//
//  APIResponse.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//

import Foundation

struct MovieResponse: Codable ,Sendable {
    let page: Int
    let results: [Movie]//ここに映画の配列が配列が入る
    let totalPage: Int
    
    enum CodingKeys: String, CodingKey {//スネークケースをキャメルケースに変換
        case page
        case results
        case totalPage = "total_pages"
    }
}
