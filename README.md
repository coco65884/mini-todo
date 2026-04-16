# Mini Todo

macOS 用の軽量 Todo リスト & メモアプリ。グローバルホットキーで瞬時に呼び出せるフローティングパネル。

## 機能

### Todo
- グローバルホットキー (デフォルト: `Ctrl+Opt+T`) でパネルを表示/非表示
- 「前日以前の残 Todo」と「今日の Todo」の 2 セクション表示
- 表示時は入力欄にフォーカス済み。タスクを入力して `Cmd+Enter` で登録
- チェックで完了。終了タスクの表示/非表示切替

### Memo
- 簡易メモの蓄積・削除
- 改行可能な複数行入力。`Cmd+Enter` で登録
- メモをクリックで再編集 (入力欄に内容が移動)
- `Tab` キーで Todo / Memo を切替

### 設定
- パネル右上の歯車アイコン、またはメニューバーのチェックリストアイコンから設定画面を開く
- 修飾キー (Ctrl / Opt / Shift / Cmd) とキー (A-Z) を自由に組み合わせ

## 動作環境

- macOS 14.0 (Sonoma) 以降
- Xcode Command Line Tools または Xcode

## インストール

```bash
git clone https://github.com/coco65884/mini-todo.git
cd mini-todo
./scripts/install.sh
```

`/Applications/MiniTodo.app` にインストールされます。Spotlight や Launchpad から起動できます。

> **Note**: 初回起動時は右クリック > 「開く」で Gatekeeper の警告を回避してください。

### 自動起動の設定

Mini Todo は起動中のみホットキーが有効です。ログイン時に自動起動するには:

1. **システム設定** > **一般** > **ログイン項目とエクステンション** を開く
2. 「ログイン時に開く」に **MiniTodo** を追加

初回起動時にパネル内にも案内が表示されます。

## アップデート

```bash
cd mini-todo
git pull
./scripts/install.sh
```

## アンインストール

```bash
cd mini-todo
./scripts/uninstall.sh
```

## 開発

```bash
# ビルド
swift build

# 実行
swift run

# テスト
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swift test

# リント
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer swiftlint lint --strict Sources/ Tests/
```

## キーコンフィグの変更

1. パネル右上の **歯車アイコン** をクリック（またはメニューバーのチェックリストアイコン > 「設定...」）
2. 修飾キーとキーを選択して「保存」

デフォルトのホットキーは `Ctrl+Opt+T` です。

## データ保存場所

Todo とメモのデータは以下に JSON 形式で保存されます:

```
~/Library/Application Support/MiniTodo/todos.json
~/Library/Application Support/MiniTodo/memos.json
```
