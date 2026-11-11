# Movie Search App

TMDB API を使って映画を閲覧し、お気に入りに登録できる iOS アプリです。
CyberAgent iOS Bootcamp (Winter 2025) の最終課題として作成し、ベストグロース賞をいただきました。

提出したソースコードのうち、この課題の分だけをポートフォリオ用に切り出したリポジトリです。

## 主な機能

- 無限スクロールによる一覧の追加読み込み
- お気に入りの登録・解除（UserDefaults に保存）
- お気に入り登録時のハートのアニメーション
- お気に入りが 0 件のときの案内表示

## 技術スタック

| 項目 | 内容 |
| --- | --- |
| 言語 | Swift 5 |
| UI | SwiftUI |
| アーキテクチャ | MVVM + Repository + 依存性注入 (DI) |
| 通信 | URLSession |
| 画像読み込み | [Kingfisher](https://github.com/onevcat/Kingfisher) (Swift Package Manager) |
| 永続化 | UserDefaults |
| テスト | XCTest |

## 動作環境

- macOS と Xcode 15 以降 (開発は Xcode 26.1 で行っています)
- iOS 17.0 以降

## セットアップ

### 1. クローン

```bash
git clone https://github.com/omomi-moti/ca-bootcamp-movie-app.git
cd ca-bootcamp-movie-app
```

### 2. TMDB のアクセストークンを用意する

1. [TMDB](https://www.themoviedb.org/) のアカウントを作成します。
2. 設定の API ページで「API Read Access Token」を取得します。

### 3. トークンを設定する

`Day3Homework/Utilities/Constants.swift` の `tmdbAccessToken` に、取得したトークンを入れてください。

```swift
static let tmdbAccessToken = "取得したトークン"
```

トークンを書いたファイルを誤ってコミットしないよう注意してください。
コミットしたくない場合は、次のコマンドで変更を git の追跡対象から外せます。

```bash
git update-index --skip-worktree Day3Homework/Utilities/Constants.swift
```

### 4. ビルドと実行

Xcode で開く場合:

1. `Day3Homework.xcodeproj` を開きます。初回は Swift Package (Kingfisher) が自動で解決されます。
2. スキーム `Day3Homework` とシミュレータを選び、`Cmd + R` で実行します。

コマンドラインでビルドする場合:

```bash
xcodebuild build \
  -project Day3Homework.xcodeproj \
  -scheme Day3Homework \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

`name=` には、手元にあるシミュレータ名を指定してください。一覧は `xcrun simctl list devices available` で確認できます。

## テスト

テストはネットワークに接続せず、Mock を使って実行されます。API トークンの設定は不要です。

Xcode では `Cmd + U` で実行できます。

コマンドラインでは次のとおりです。

```bash
xcodebuild test \
  -project Day3Homework.xcodeproj \
  -scheme Day3Homework \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

テストの内容は次のとおりです。

| ファイル | 確認していること |
| --- | --- |
| `MovieListViewModelTests` | 一覧の最後の要素が表示されたときだけ追加読み込みが走ること。それ以外のタイミングで API を呼ばないこと |
| `FavoritesManagerTests` | お気に入りの保存・削除ができ、再起動後もデータが残ること。テスト専用の UserDefaults を使い、実機のデータには触れない |

## ディレクトリ構成

```
Day3Homework/
├── Day3HomeworkApp.swift
├── Models/            Movie, APIResponse
├── Services/          API 通信 (MovieService)、お気に入り保存 (FavoritesManager)、エラー定義
├── ViewModels/        MovieListViewModel
├── Views/             RootView, FavoriteView, Components
└── Utilities/         Constants (API の URL とトークン)
Day3HomeworkTests/     XCTest
```

## 設計について

- **View** は描画だけを担当します。
- **ViewModel** は画面の状態と表示用のロジックを持ちます。
- **Service (Repository)** は通信の詳細を隠します。`MovieServiceProtocol` を介して ViewModel に渡すため、ViewModel を変更せずに本番の通信と Mock を差し替えられます。

テストを書きやすい形にすることを、設計の判断基準にしました。

## 開発記事

設計の背景や学んだことは Qiita にまとめています。
「iOS未経験者がCAブートキャンプでベストグロース賞を取るまで」
