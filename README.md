# 🎬 Movie Search App (iOS)

CyberAgent iOS Bootcamp (Winter 2025) Final Task  
🏆 Best Growth Award（ベストグロース賞）受賞作品

---

## 🎬 Overview
本アプリは、映画を検索・閲覧し、お気に入り管理ができるiOSアプリです。  
CyberAgent iOS Bootcamp (Winter 2025) の最終課題として開発し、  
「実務を意識した設計」「テストによる品質担保」「心地よいUI/UX」の両立を目標にしました。

MVVM + Repository パターンと Dependency Injection を採用し、  
保守性・拡張性・テスト容易性を重視した構成で実装しています。

> Note: 本リポジトリは、ブートキャンプに提出した最終課題のソースコードを  
> ポートフォリオ用に抽出したものです。（講義資料・他の課題コードは含んでいません）

---

## 📸 Screenshots
（スクリーンショット / GIF を配置）

---

## 📘 開発記事（Dev Story）
設計背景・技術選定の理由・学習プロセスについては、Qiitaに詳細をまとめています。  
👉 Qiita: 「iOS未経験者がCAブートキャンプでベストグロウ賞を取るまで」

---

## 🧩 技術スタック（Tech Stack）

- Language: Swift 5  
- UI: SwiftUI  
- Architecture: MVVM + Repository Pattern + Dependency Injection  
- Networking: URLSession  
  → 標準APIを用いた責務分離とテスト容易性を重視  
- Image Loading: Kingfisher  
- Persistence: UserDefaults  
  → 軽量な永続化に限定し、過剰設計を避けるため採用  
- Testing: XCTest  

---

## 💡 こだわりの設計（Architecture Strategy）

「テストが書けるコードは、設計が良いコードである」という考えのもと、責務分離を徹底しました。

### 1. MVVM + Repository Pattern + DI
Viewとロジックを分離するだけでなく、Protocol を用いてデータ取得元を抽象化しました。

- View: UIの描画のみに専念  
- ViewModel: 画面表示用の状態管理・ロジック  
- Repository: API通信の実装詳細を隠蔽  

✅ 成果  
ViewModelのコードを一切変更することなく、「本番通信」と「Mock（テスト用データ）」を切り替え可能にし、  
オフラインでも開発・テストが行える構成を実現しました。

---

### 2. 品質担保への挑戦（Testing with XCTest）
Unit Test を導入し、「なんとなく動く」ではなく「確実に動く」状態を担保しました。

- ViewModel Tests  
  - 境界値テスト：無限スクロール時、「最後の要素が表示された時のみ」追加読み込みが走ることを検証  
  - APIスパム防止：不要なタイミングで通信が走らないことを Mock を用いて検証  

- Persistence Tests（FavoritesManager）  
  - Sandboxing：テスト専用 UserDefaults を用意し、実機データを汚さずに  
    保存・削除・再起動後のデータ保持を検証  

---

## 🎨 UI/UXでこだわったポイント

「機能要件を満たすだけでなく、使っていて心地よいアプリ」を目指し、  
細部（Micro-interactions）まで作り込みました。

- ❤️ ハートのアニメーション  
  - scaleEffect と spring() を組み合わせ、お気に入り登録時に「ポヨン」と弾む動きを実装  

- 🚫 Empty State の工夫  
  - 単なる空表示ではなく、「登録を促すメッセージ」を表示し、ユーザーの不安を軽減  

- ♾ 無限スクロール（Infinite Scroll）  
  - 「もっと見る」ボタンを廃止し、リスト最下部で自動読み込みを行うことで没入感を向上  

- ⚙️ ロード演出  
  - 再読み込み中に歯車アニメーションを表示し、処理中であることを直感的にフィードバック  

---

## 🔥 苦労した点・学んだこと（Challenges）

- Dependency Injection の理解と実装  
  - Protocol を導入することで、テスト時に Mock に差し替え可能になる意義を実装を通して体感し、  
    依存性逆転の原則（DIP）への理解が深まりました。

- テスト設計の難しさ  
  - 「何をテストすべきか」に悩みましたが、「ユーザーに不利益がある不具合」を基準に  
    重要ロジックから優先的にテストを書く方針に切り替えました。

---

## 🚀 セットアップ方法

1. git clone  
2. Xcodeでプロジェクトを開く  
3. `Utilities/Constants.swift` (または該当ファイル) にTMDBのAPIキーを設定
4. build & run  

---

## 🛠 動作環境

- Xcode 15.x  
- iOS 17.x  

