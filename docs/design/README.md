# Tales-like JRPG 設計ドキュメント

テイルズ オブ エターニア風 2D アクションRPG (Godot Engine 4.7 / 2D) の設計資料。
設計エージェント (GameDesigner) が作成し、各エージェントへ共有する起点となるドキュメント群。

## ドキュメント一覧
| ファイル | 内容 | 主対象 |
| --- | --- | --- |
| [`00_game_design.md`](00_game_design.md) | ゲーム基本仕様（ジャンル/世界観/戦闘/マップ） | 全員 |
| [`01_asset_list.md`](01_asset_list.md) | 必要素材リスト | AssetManager |
| [`02_asset_prompts.md`](02_asset_prompts.md) | 外部AI向け素材生成プロンプト | AssetManager |
| [`03_programmer_spec.md`](03_programmer_spec.md) | 最初の実装仕様書（Phase 1） | Programmer |

## エージェント体制と進行ルール
```
GameDesigner ──仕様──▶ Programmer ──実装──▶ AssetManager ──素材──▶ Tester ──報告──▶ (GameDesignerへ改善還元)
```
- 進行順: 設計 → コーディング → アセット管理 → テスト。
- 各エージェントは次のエージェントに「タスク依頼」を送る。
- 不明点は必ず前のエージェントに質問してから進める。
- Usage削減のため、コードは必要最小限にまとめる。
- 素材は外部AIで生成し、DevinDesktop内では素材生成を行わない。

## 現在地
- **Phase 0 完了**: キャラ選択 + 町探索 + プレイヤー移動（プロトタイプ）。
- **Phase 1 (次の実装)**: `03_programmer_spec.md` を参照。Programmer へ依頼済み。

## 各エージェントへの最初のタスク依頼
- **Programmer**: `03_programmer_spec.md` の P1 (T1〜T6) を実装。着手前に §7 の確認事項を確認。
- **AssetManager**: `01_asset_list.md` の P1優先素材（town/field tileset・battle背景・UI基本）を
  `02_asset_prompts.md` のプロンプトで外部AI生成し、想定パスへ配置。
- **Tester**: P1 の DoD（`03_programmer_spec.md` §8）に沿って一連フローを動作確認、バグ報告。
