//
//  Day3HomeworkTests.swift
//  Day3HomeworkTests
//
//  Created by 鈴木聖也 on 2026/01/07.
//

import Foundation
@testable import Day3Homework

//一旦sendableを一時的に無視する
final class MockMovieService: MovieServiceProtocol ,@unchecked Sendable{
    //result型で成功したときは[Movie],失敗した時はErrorをはく
    var resultToReturn : Result<[Movie],Error>?
    var searchResultToReturn: Result<[Movie],Error>?
    
    var fetchPopularMoviesCallCount = 0
    var searchMovieCallCount = 0
    
    
    //デバック用にモックデータを投げれるように宣言する
    func fetchPopularMovies(page: Int) async throws -> [Movie] {
        
        fetchPopularMoviesCallCount += 1
        //オプショナル型なのかをチェックしている
        guard let result = resultToReturn else {
            return []
        }
        //resultが成功している値を所持しているのか、エラーを持っているのか判断している
        switch result {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }
    //デバック用にモックデータを投げれるように宣言する
    func searchMovie(query: String) async throws -> [Movie] {
        searchMovieCallCount += 1
        //オプショナル型なのかをチェックしている
        guard let result = searchResultToReturn else {
            return []
        }
        //resultが成功している値を所持しているのか、エラーを持っているのか判断している
        switch result {
        case .success(let movies):
            return movies
        case .failure(let error):
            throw error
        }
    }
}
