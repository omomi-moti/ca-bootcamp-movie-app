//
//  MovieServiceProtocol.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//
import Foundation

protocol MovieServiceProtocol : Sendable{
    func fetchPopularMovies(page:Int) async throws  -> [Movie]
    func searchMovie(query: String) async throws -> [Movie]
}


