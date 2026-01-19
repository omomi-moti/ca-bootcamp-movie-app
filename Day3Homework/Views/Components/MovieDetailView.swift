import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    let movie: Movie
    
    // 管理人を呼び出す (データが変わったら画面も更新される)
    @EnvironmentObject var favoritesManager: FavoritesManager
    //ハートのアニメーションのためのフラグ
    @State private var isHeartAnimating: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 画像エリア
                KFImage(movie.posterImageURL)
                    .fade(duration: 0.3)
                    .resizable()
                    .placeholder { Rectangle().fill(Color.gray.opacity(0.3)) }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 16) {
                    // タイトルとハートボタン
                    HStack(alignment: .top) {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .layoutPriority(1)
                        
                        Spacer()
                        
                        Button {
                            // 振動フィードバック (UX向上)
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                favoritesManager.toggleFavorite(movie)
                                isHeartAnimating = true
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { // 時間を少し調整しました
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                    isHeartAnimating = false
                                }
                            }
                        } label: {
                            // 状態によってハートの色と形を変える
                            Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesManager.isFavorite(movie) ? .red : .gray)
                                .font(.system(size: 30))
                                .padding(8)
                                .scaleEffect(isHeartAnimating ? 1.3 : 1.0)//アニメーションのサイズ適応
                        }
                    }
                    
                    // 評価などの情報
                    HStack {
                        Label(movie.releaseDate ?? "不明", systemImage: "calendar")
                        Spacer()
                        Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("あらすじ")
                        .font(.headline)
                    
                    Text(movie.overview.isEmpty ? "あらすじ情報はありません。" : movie.overview)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding()
            }
        }
        .navigationTitle("映画詳細")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
}
