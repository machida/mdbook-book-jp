# mdbook-book-jp

日本語の mdBook 書籍向けの共通テーマです。

## 含まれるもの

CSS は 2 層に分かれています。

- `theme/mdbook-book-core.css`
  - mdBook の共通レイアウト
- `theme/mdbook-book-jp.css`
  - 日本語書籍向けの余白・文字組み調整。`mdbook-book-core.css` の上に重ねて使います。

このテーマは現在、**`@import` に依存せず**、`book.toml` の `additional-css` に
`mdbook-book-core.css` と `mdbook-book-jp.css` を**明示的に並べる**設計です。
mdBook の配信先やビルド環境によっては、`@import` 先の CSS が期待どおりに
配布されないことがあるためです。

導入用のスクリプトは 2 つあります。

- `bin/install.sh`
  - **初回導入用。** 対象の mdBook プロジェクトにテーマ CSS を置き、`book.toml` を設定します。
- `bin/update.sh`
  - **再適用用。** すでに導入済みのプロジェクトへ、最新版のテーマを入れ直すラッパーです。中身は `install.sh` をそのまま呼ぶだけなので、やることは初回導入と同じです。

## 使い方

スクリプトは **`mdbook-book-jp` を clone（または展開）したディレクトリで実行し、導入先のプロジェクトは引数で渡します。** 導入先のディレクトリへ `cd` する必要はありません。

たとえば `mdbook-book-jp` が `~/dev/mdbook-book-jp` にあり、あなたの本が `~/dev/my-cookbook` にあるなら、次の 2 行で導入できます。

```bash
cd ~/dev/mdbook-book-jp
bash ./bin/install.sh ~/dev/my-cookbook
```

スクリプトを絶対パスで呼べば、`cd` も不要です。

```bash
bash ~/dev/mdbook-book-jp/bin/install.sh ~/dev/my-cookbook
```

導入後、導入先の `book.toml` には次の設定が入ります。

- `language = "ja"`
- `additional-css = ["theme/mdbook-book-core.css", "theme/mdbook-book-jp.css"]`

また、導入先の `theme/` に次の 2 ファイルが置かれます。

- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

### additional-css の並び順

`additional-css` は **書いた順に読み込まれ、あとに書いたものが先のものを上書きします。** そのため並び順には意味があります。

- 先に **テーマ本体**（`theme/mdbook-book-jp.css`）
- さらにその前に **共通レイアウト層**（`theme/mdbook-book-core.css`）
- そのあとに **書籍固有の上書き CSS**

本書側に `theme/tailwind-css-textbook.css` のような独自 CSS がある場合は、テーマより**あとに**並べてください。

```toml
[output.html]
additional-css = [
  "theme/mdbook-book-core.css",      # 先：共通レイアウト層
  "theme/mdbook-book-jp.css",        # 中：日本語向け調整
  "theme/tailwind-css-textbook.css", # 後：書籍固有の上書き
]
```

`install.sh` は `theme/mdbook-book-core.css` と `theme/mdbook-book-jp.css` を `additional-css` の先頭へ並べ直し、既存の書籍固有 CSS はその後ろに残します。

## 更新する

`mdbook-book-jp` は更新されることがあります。あなたの本に入れたテーマも、最新版に合わせて入れ直せます。再適用には `update.sh` を使います。

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

Release 版を展開して使っているなら、新しい `tar.gz` をダウンロードして展開し直し、そのディレクトリから再適用します。

```bash
tar -xzf mdbook-book-jp-0.1.1.tar.gz
cd mdbook-book-jp-0.1.1
bash ./bin/update.sh ~/dev/my-cookbook
```

`update.sh` は `install.sh` を呼ぶだけなので、行うことは初回導入と同じです。

- `book.toml` に `language = "ja"` を追加
- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-core.css` と `theme/mdbook-book-jp.css` を追加

再実行しても `book.toml` の設定は重複しないので、更新目的で何度実行しても大丈夫です。

### テーマ設計を変えたときの注意

テーマ本体の CSS 設計や読み込み契約を変えた場合は、`mdbook-book-jp` リポジトリ
だけを更新して終わりではありません。**そのテーマを取り込んでいる各書籍でも**
次を行ってください。

```bash
bash ./bin/update.sh /path/to/book-project
```

理由は、各書籍が `theme/mdbook-book-core.css` / `theme/mdbook-book-jp.css` を
**コピーとして保持している**からです。`book.toml` だけ直しても、書籍側の
`theme/` 内ファイルが古いままだと、今回のように設計変更と実ファイルが食い違って
表示崩れを起こします。

## 配布物を作る

ここでいう「配布物」は、GitHub の Release などに置いて、使う人がそのままダウンロードできる `tar.gz` のことです。ソース一式ではなく、**導入に必要なファイルだけ**をまとめた完成パッケージです。

このリポジトリのルートで次を実行します。`VERSION` を付けると、その名前で `dist/` に出力されます。

```bash
VERSION=0.1.0 ./bin/package.sh
# => dist/mdbook-book-jp-0.1.0.tar.gz
```

配布物に含まれるのは、導入に必要な次のファイルだけです。

- `README.md`
- `LICENSE`
- `bin/install.sh` / `bin/update.sh` / `bin/package.sh`
- `theme/mdbook-book-core.css`
- `theme/mdbook-book-jp.css`

### 配布物を使う側の手順

clone 版と同じく、**展開したディレクトリ直下の `bin/install.sh` を実行し、導入先は引数で渡します。**

```bash
tar -xzf mdbook-book-jp-0.1.0.tar.gz
cd mdbook-book-jp-0.1.0
./bin/install.sh ~/dev/my-cookbook
```

`install.sh` が行うことは clone 版と同じです。

- `book.toml` に `language = "ja"` を追加
- `theme/` に共通 CSS を配置
- `book.toml` の `additional-css` に `theme/mdbook-book-core.css` と `theme/mdbook-book-jp.css` を追加

## 方針

- 日本語の本文が読みやすいことを優先する
- ブラックボックスとして使えることを優先し、利用側は CSS を触らなくてよい
- 共通レイアウト層と日本語特化層を分けて、このテーマを導入する mdBook 書籍でも再利用しやすいようにする
- 表は、狭い画面で無理に潰さず、必要に応じて横スクロールさせて読む方針を取る
- mdBook が出力する `.table-wrapper` を前提に、テーブル本体ではなくラッパー側に横スクロール責務を持たせる

## 表の扱い

このテーマでは、表を「本文中の補助情報」ではなく、独立して読まれる要素として扱います。  
そのため、次の方針で見た目を整えています。

- セルに十分な余白を入れる
- ヘッダー行を本文より少し強く見せる
- 偶数行にごく薄い背景を入れて視線を追いやすくする
- ヘッダーセルは不自然に折り返さず、必要なら表全体を横スクロールさせる
- 狭い画面では、無理に列幅を潰して読みにくくしない

特に日本語の技術書では、列見出しが中途半端に 2 行へ折り返されると一気に読みづらくなります。  
このテーマは「多少横に長くなっても、見出しの意味が一目で読める」方を優先します。
