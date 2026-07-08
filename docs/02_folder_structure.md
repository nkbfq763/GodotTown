# フォルダ構成設計

新規プロジェクトとして以下の構成を採用する（Godot 公式のスタイルガイドに準拠: snake_case、機能別分割）。

```
GodotTown/  (Godot プロジェクトルート)
├── project.godot
├── docs/                        # 設計ドキュメント（本ファイル群）
│   ├── 01_game_design.md
│   ├── 02_folder_structure.md
│   └── 03_asset_generation.md
├── assets/                      # 生データ（画像・音声・フォント）
│   ├── characters/
│   │   └── heroine/             # 主人公スプライトシート (walk_up/down/left/right)
│   ├── tilesets/                # 町・ダンジョン用タイルセット画像
│   ├── ui/                      # ウィンドウ枠・タイトルロゴ等
│   ├── fonts/                   # PixelMplus 等の無料フォント
│   ├── music/                   # BGM (.ogg)
│   └── sfx/                     # 効果音 (.ogg/.wav)
├── scenes/                      # シーン (.tscn) とそれに1対1対応するスクリプト
│   ├── title/
│   │   ├── title.tscn
│   │   └── title.gd
│   ├── town/
│   │   ├── town.tscn            # 町マップ（TileMapLayer + スポーン地点 + 出口）
│   │   └── town.gd
│   ├── dungeons/                # P3 以降。ダンジョンごとにサブフォルダ
│   │   └── (dungeon_01/ ...)
│   ├── characters/
│   │   ├── player/
│   │   │   ├── player.tscn      # CharacterBody2D + AnimatedSprite2D + Camera2D
│   │   │   └── player.gd
│   │   └── npcs/                # P2 以降
│   └── ui/
│       └── (dialogue_box.tscn 等、P2 以降)
├── scripts/                     # シーンに紐付かない共通スクリプト
│   ├── autoload/
│   │   └── game_manager.gd      # シーン遷移・ゲーム状態（autoload 登録）
│   └── resources/               # カスタム Resource 定義 (character_stats.gd 等)
├── resources/                   # .tres リソース（TileSet、SpriteFrames、Theme）
│   ├── tilesets/
│   │   └── town_tileset.tres
│   ├── sprite_frames/
│   │   └── heroine_frames.tres
│   └── themes/
│       └── default_theme.tres
└── addons/                      # 将来のプラグイン用（Dialogic 等を想定）
```

## ルール

1. **assets/** には元データ（png/ogg/ttf）のみを置き、Godot リソース化したもの（.tres）は **resources/** に置く
2. **scenes/** は「1シーン = 1フォルダ」を基本とし、シーン専用スクリプトは同フォルダに置く
3. シーンをまたいで使うロジックは **scripts/autoload/**（シングルトン）へ
4. 命名はすべて **snake_case**（ファイル・フォルダ）、クラス名は PascalCase
5. 旧プロトタイプのファイル（ルート直下の .gd / .tscn）は新構成へ移行後に削除する

## P1 で実際に作成するファイル

- `scenes/title/title.tscn` / `title.gd` — 「はじめる」ボタンで町へ
- `scenes/town/town.tscn` / `town.gd` — TileMapLayer 製の町
- `scenes/characters/player/player.tscn` / `player.gd` — 移動・アニメ・カメラ
- `scripts/autoload/game_manager.gd` — `change_scene_to()` ラッパー
- `resources/tilesets/town_tileset.tres`、`resources/sprite_frames/heroine_frames.tres`
