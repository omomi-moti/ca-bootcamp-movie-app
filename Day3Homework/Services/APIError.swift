//
//  APIError.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/30.
//
//エラーの種類を定義にする、単なる失敗ではなく、何が原因かかを明確にする
import Foundation


//
enum APIError: Error, LocalizedError{
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self{
        case .invalidURL: return "無効なURLです。"
        case .networkError(let error): return "通信エラー: \(error.localizedDescription)"
        case .decodingError: return "データ解析に失敗しました"
        case .unknown: return "不明なエラー"
        }
    }
}
