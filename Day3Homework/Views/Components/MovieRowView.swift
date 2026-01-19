//
//  MovieRowView.swift
//  Day3Homework
//
//  Created by 鈴木聖也 on 2025/12/31.
//

import SwiftUI
import Kingfisher //URLから画像を取得して、非同期表示・キャッシュ管理までを自動でやってくれるライブラリ

struct MovieRowView: View {
    let movie: Movie//映画の情報を取得
    var body: some View {
        HStack(alignment: .top,spacing: 16){
            //URl型を渡すだけでキャッシュ、非同期読み込みを全部やってくれる
            KFImage(movie.posterImageURL)
                .fade(duration: 0.3) // 0.3秒かけて表示
                .resizable()
                .placeholder{
                    //読み込み中はグレーの四角の表示
                    Rectangle().fill(Color.gray.opacity(0.3))
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 120) // ポスターの縦横比に近いサイズ
                .cornerRadius(8)
                .clipped()
            
            
            VStack(alignment: .leading, spacing: 8){
                
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                if let date = movie.releaseDate {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
                
                HStack(spacing: 4) {
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption)
                        .fontWeight(.bold)
                    
                }
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
