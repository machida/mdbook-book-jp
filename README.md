# mdbook-book-jp

日本語の mdBook 書籍向けの共通テーマです。

## 含まれるもの

- `theme/mdbook-book-core.css`
  - mdBook の共通レイアウト
- `theme/mdbook-book-jp.css`
  - 日本語書籍向けの余白・文字組み調整
- `bin/install.sh`
  - 既存の mdBook プロジェクトへテーマを導入するスクリプト

## 使い方

既存の mdBook プロジェクトのルートで実行します。たとえば、あなたの本が
`~/dev/my-cookbook` にあるなら、そのディレクトリで導入します。

```bash
cd ~/dev/my-cookbook
./bin/install.sh .
```

パスを直接書く場合は、次のようにもできます。

```bash
./bin/install.sh ~/dev/my-cookbook
```

導入後は、`book.toml` に次の設定が入ります。

- `language = "ja"`
- `additional-css = ["theme/mdbook-book-jp.css"]`

また、`theme/` には次の 2 ファイルが置かれます。

- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

## 配布物を作る

ここでいう「配布物」は、GitHub の Release などに置いて、使う人がそのままダウンロードできる
`tar.gz` のことです。ソース一式をそのまま渡すのではなく、導入に必要なファイルだけをまとめた
完成パッケージを作ります。

このリポジトリのルートで次を実行します。

```bash
./bin/package.sh
```

たとえば `VERSION=0.1.0` を付けると、`dist/mdbook-book-jp-0.1.0.tar.gz` ができます。

```bash
VERSION=0.1.0 ./bin/package.sh
```

中身は次の通りです。

- `README.md`
- `LICENSE`
- `bin/install.sh`
- `bin/package.sh`
- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

つまり、配布物を展開したあとも、そのまま `install.sh` を使って別の mdBook プロジェクトへ導入できます。

### 配布物を使う側の手順

1. `tar.gz` をダウンロードする
2. 展開する
3. 展開したディレクトリの `bin/install.sh` を実行する

たとえば、別の本が `~/dev/my-cookbook` にあるなら、次のようにします。

```bash
tar -xzf mdbook-book-jp-0.1.0.tar.gz
cd mdbook-book-jp-0.1.0
./bin/install.sh ~/dev/my-cookbook
```

`package.sh` と `install.sh` が行うことは次の通りです。

- `book.toml` に `language = "ja"` を追加
- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-jp.css` を追加

## 方針

- 日本語の本文が読みやすいことを優先する
- ブラックボックスとして使えることを優先し、利用側は CSS を触らなくてよい
- 共通レイアウト層と日本語特化層を分けて、他の書籍にも再利用しやすくする
