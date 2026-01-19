import SwiftUI

struct PopularView: View {
    // ViewModelを生成 (StateObject: 画面が破棄されるまで生き続ける)
    @StateObject private var viewModel = MovieListViewModel()
    var body: some View {
        NavigationStack{
            Group{
                if let error = viewModel.errorMessage {
                    VStack(spacing: 16){
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("再読み込み") {
                            Task { await viewModel.loadMovies() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                }
                //初回ロード中の表示（データがまだ空っぽの時）
                else if viewModel.movies.isEmpty && viewModel.isLoading{
                    //くるくる回るインジケータを表示
                    ProgressView("読み込み中")
                }
                else{
                    List{
                        ForEach(viewModel.movies) { movie in
                            
                            //詳細画面のリンク
                            NavigationLink(destination: MovieDetailView(movie: movie)){
                                MovieRowView(movie: movie)
                                    .onAppear {
                                        Task{
                                            await viewModel.loadMoreContent(currentItem: movie)
                                        }
                                    }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable{
                        await viewModel.loadMovies()
                    }
                }
            }
            .navigationTitle("人気映画")
        }
        .task {
            //すでにデータがあるときは再ロードしないように制御しても良い
            if viewModel.movies.isEmpty {
                await viewModel.loadMovies()
            }
        }
    }
}


#Preview {
    PopularView()
}
