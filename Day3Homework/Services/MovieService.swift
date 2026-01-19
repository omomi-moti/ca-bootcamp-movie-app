//
//  MovieService.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//

//actorにするか、ステートなstruct,classにするかは後で考える
//ここでは状態を持たないため、structで定義することでDIしやすくする

import Foundation

struct MovieService : MovieServiceProtocol{
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    // イニシャライザでURLSessionを注入できるようにする (テストでMockSessionを渡せるようにするため)
    //今回はテストは実装しない
    init(session: URLSession = .shared){
        self.session = session
        self.decoder = JSONDecoder()
        
    }
    
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        let endpoint = "/movie/popular"
        let queryItems = [URLQueryItem(name: "page", value: "\(page)")] //これ何？
        return try await performRequest(endpoint: endpoint,queryItems :queryItems)
    }
    
    func searchMovie(query: String) async throws -> [Movie]{
        let endpoint = "/search/movie"
        let queryItems = [URLQueryItem(name: "query", value: query)]
        return try await performRequest(endpoint: endpoint,queryItems :queryItems)
    }
    
    /// 共通の通信処理 (Private)
    private func performRequest(endpoint: String, queryItems: [URLQueryItem]) async throws -> [Movie] {
        // 1. URL構築 (api_key はURLに含めない！)
        var components = URLComponents(string: Constants.baseURL + endpoint)
        
        // 言語設定などのクエリパラメータ
        var allQueryItems = [URLQueryItem(name: "language", value: "ja-JP")]
        allQueryItems.append(contentsOf: queryItems)
        components?.queryItems = allQueryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        // 2. リクエスト作成 (ここでアクセストークンをヘッダーにセット)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            // 👇 ここで Bearer (ベアラー) 認証を行います
            "Authorization": "Bearer \(Constants.tmdbAccessToken)"
        ]
        
        print("🌍 URL確認: \(url.absoluteString)") // デバッグ用
        
        // 3. 通信実行 (URLではなく request を渡す形に変更)
        do {
            let (data, response) = try await session.data(for: request)
            
            // ステータスコードのチェック
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 ステータスコード: \(httpResponse.statusCode)")
                
                if !(200...299).contains(httpResponse.statusCode) {
                    // 401ならトークンミス、404ならURLミスの可能性
                    throw APIError.unknown
                }
            }
            
            // 4. デコード
            let decodedResponse = try decoder.decode(MovieResponse.self, from: data)
            return decodedResponse.results
            
        } catch let decodingError as DecodingError {
            print("デコードエラー: \(decodingError)")
            throw APIError.decodingError(decodingError)
        } catch {
            print("通信エラー: \(error)")
            throw APIError.networkError(error)
        }
    }
}
