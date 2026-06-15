# mdbook-book-jp

日本語の mdBook 書籍向けの共通テーマです。

## 含まれるもの

- `theme/mdbook-book-core.css`
  - mdBook の共通レイアウト
- `theme/mdbook-book-jp.css`
  - 日本語書籍向けの余白・文字組み調整
- `bin/install.sh`
  - 既存の mdBook プロジェクトへテーマを導入するスクリプト
- `bin/update.sh`
  - いったん導入した mdBook プロジェクトへ、最新版のテーマを再適用するスクリプト

## 使い方

既存の mdBook プロジェクトのルートで実行します。たとえば、あなたの本が
`~/dev/my-cookbook` にあるなら、そのディレクトリで導入します。

```bash
cd ~/dev/mdbook-book-jp
bash ./bin/install.sh ~/dev/my-cookbook
```

このリポジトリを clone した場所が `~/dev/mdbook-book-jp` で、導入先が
`~/dev/my-cookbook` なら、上の 2 行で十分です。

インストールスクリプトを絶対パスで呼ぶこともできます。

```bash
bash ~/dev/mdbook-book-jp/bin/install.sh ~/dev/my-cookbook
```

導入後は、`book.toml` に次の設定が入ります。

- `language = "ja"`
- `additional-css = ["theme/mdbook-book-jp.css"]`

また、`theme/` には次の 2 ファイルが置かれます。

- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

## 更新する

`mdbook-book-jp` は更新されることがあります。あなたの本に入れたテーマも、最新版に合わせて
更新できます。

### Git clone で持っている場合

このリポジトリを clone して手元に置いてあるなら、まず本体を更新します。

```bash
cd ~/dev/mdbook-book-jp
git pull --ff-only
```

次に、使っている書籍へテーマを再適用します。

```bash
bash ./bin/update.sh ~/dev/my-cookbook
```

### Release tarball で持っている場合

Release 版を展開して使っているなら、新しい `tar.gz` をダウンロードして展開し直し、
そのディレクトリから更新します。

```bash
tar -xzf mdbook-book-jp-0.1.1.tar.gz
cd mdbook-book-jp-0.1.1
bash ./bin/update.sh ~/dev/my-cookbook
```

`update.sh` は `install.sh` と同じく、次を行います。

- `book.toml` に `language = "ja"` を追加
- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-jp.css` を追加

再実行しても `book.toml` は重複しないので、更新時に使っても大丈夫です。

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
- `bin/update.sh`
- `bin/package.sh`
- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

つまり、配布物を展開したあとも、そのまま `install.sh` を使って、このテーマを導入する別の mdBook プロジェクトで使えます。

### 配布物を使う側の手順

1. `tar.gz` をダウンロードする
2. 展開する
3. 展開したディレクトリの `bin/install.sh` を実行する

たとえば、導入先の mdBook プロジェクトが `~/dev/my-cookbook` にあるなら、次のようにします。

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
- 共通レイアウト層と日本語特化層を分けて、このテーマを導入する別の mdBook 書籍でも再利用しやすいようにする
