# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際のClaude Code (claude.ai/code)向けのガイダンスを提供します。

## コマンド

### テスト
- テスト実行: `bundle exec rake spec` または `bundle exec rspec`
- 特定のRailsバージョンでのテスト実行: `BUNDLE_GEMFILE=gemfiles/Gemfile.rails-7.0 bundle exec rspec`
- 利用可能なRailsバージョン: 6.1, 7.0, 7.1, 7.2 (gemfilesディレクトリを参照)
- レガシーサポート: Rails 4.2.1, 5.0, 6.0用のGemfileも存在しますが、非推奨です

### 開発
- 依存関係のインストール: `bundle install`
- 対話式コンソール: `bin/console`
- 開発環境のセットアップ: `bin/setup`

### Docker開発
- MySQLとアプリコンテナの起動: `docker-compose up`
- MySQLはポート3307 (ホスト) / 3306 (コンテナ)で利用可能

## アーキテクチャ

### コア構造
これはActiveRecordモデルにMySQLテーブルパーティショニング機能を提供するRuby gemです。このgemはモジュラー設計に従っています：

- **SimpleMySQLPartitioning module**: ActiveRecordモデルにインクルードされるメインエントリーポイント
- **Adapter module**: モデルにクラスメソッド（`partitioning_by`、`partition`、`partition_config`）を提供
- **BasePartitioning class**: 共通のパーティション操作（`exists?`、`drop`）を持つ抽象基底クラス
- **Range class**: COLUMNSサポート付きRANGEパーティショニングの具象実装
- **SQL class**: すべてのパーティション操作用の静的SQLクエリジェネレータ

### 主要コンポーネント

#### モジュールインクルージョンパターン
`SimpleMySQLPartitioning`がモデルにインクルードされると、自動的に`Adapter`モジュールがインクルードされ、モデルクラスにパーティショニングクラスメソッドが拡張されます。

#### パーティション設定
モデルは以下でパーティショニングを定義します: `partitioning_by :column_name, type: :range`
これにより`ModelClass.partition`経由でアクセス可能なパーティションインスタンスが作成されます。

#### SQL生成
`SQL`クラスはMySQL固有のALTER TABLE文を生成します：
- RANGE COLUMNSでのパーティション作成
- 新しいパーティションの追加
- 既存パーティションの再編成
- パーティションの削除
- パーティション存在確認

#### レンジパーティショニング
現在はCOLUMNS構文を使用したRANGEパーティショニングのみをサポートしています。操作には以下が含まれます：
- `create(pairs)`: 初期パーティション作成
- `add(pairs)`: 新しいパーティションの追加
- `reorganize(pairs, name, value)`: MAXVALUEサポート付きパーティション再編成
- `exists?(name)`: パーティションの存在確認
- `drop(name)`: パーティションの削除

### データベース要件
- MySQL 8.0+が必要 (docker-compose.ymlで指定)
- データベース接続にmysql2 gemを使用
- ActiveRecord接続処理と統合
- 最小Ruby要件: 3.0.0+
- 最小ActiveRecord要件: 6.1.0+

### テストインフラストラクチャ
- データベースセットアップ・ティアダウン付きRSpecテストスイート
- マルチバージョンRails互換性テスト
- データベース設定はspec/support/ファイルで処理