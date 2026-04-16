# 開発ルール

## 基本方針
* GitHub Issues でタスクを管理する。`priority:critical` → `priority:high` の順に優先度の高いタスクから実行
* 新しいライブラリやツールを導入した場合は `docs/textbook/<topic>.md` に技術紹介を作成
* ユーザーの作業が必要な場合は `needs:human` ラベル付きの Issue を作成

## Git運用ルール

### ブランチ戦略
- 作業は必ず `feature/<TASK-ID>-<description>` ブランチで行う
- mainへの直接pushは原則禁止
- 機能(issue)ごとにブランチを切り替える
- 機能は1つずつ(1 issueずつ)実装し、実装が終わったらPushを行い、CIが通っているか、mergeされたかを確認してから次のタスクを行う

### コミットメッセージ形式
- `feat:` 新機能追加
- `fix:` バグ修正
- `data:` データ収集・更新
- `infra:` CI/CD, 設定, インフラ変更

### 作業フロー
```bash
# 1. Issue取得
gh issue edit <NUMBER> --add-assignee "@me" --add-label "agent:claimed"

# 2. ブランチ作成
git checkout -b feature/<TASK-ID>-<description> main

# 3. 実装 → テスト → commit
swift build && swift test
git commit -m "feat: <TASK-ID> <description>

Closes #<ISSUE-NUMBER>"

# 4. push → PR → merge
git push -u origin feature/<TASK-ID>-<description>
gh pr create --title "..." --body "Closes #<NUMBER>" --base main
gh pr merge --auto --squash
```

## 品質チェック

コミット前に以下を実行すること。

```bash
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
swiftlint lint --strict Sources/ Tests/  # リント
swift build                               # ビルド
swift test                                # テスト
```

> **Note**: ローカル環境では `DEVELOPER_DIR` を Xcode.app に向ける必要がある（CommandLineTools にはXCTest・SourceKit が含まれないため）。
> CI (GitHub Actions) では Xcode がデフォルト toolchain のため不要。
