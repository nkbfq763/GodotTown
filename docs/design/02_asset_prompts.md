# 外部AI向け 素材生成プロンプト集 (GameDesigner → AssetManager)

対象読者: AssetManager（外部画像生成AIへ投入）
方針: DevinDesktop内では画像生成しない。以下プロンプトを外部AI(例: 画像生成モデル)に投入して素材を得る。
言語: プロンプトは英語（画像生成AIの精度が高いため）。日本語補足を併記。

## 共通スタイル・トークン（全プロンプトに付加）

```
STYLE: "Tales of Eternia" style, anime JRPG, hand-drawn cel-shaded 2D sprite,
bright saturated colors, bold clean outlines, soft anime shading,
game asset, transparent background, PNG, no text, no watermark, no border.
```

共通ネガティブ:
```
NEGATIVE: 3d render, photorealistic, blurry, jpeg artifacts, extra limbs,
drop shadow on background, text, signature, watermark, cropped, low-res.
```

> ポイント:
> - **transparent background** を必ず指定（透過PNG）。
> - スプライトシートは **grid layout / evenly spaced cells** を明記し、セル数を固定。
> - 生成後、セルサイズが崩れる場合はセル単体で生成 → AssetManagerが結合。

---

## 1. プレイヤーキャラ

### 1-1. 女戦士 フィールド歩行シート (`warrior_field`)
```
A female warrior sprite sheet for a top-down 2D JRPG, Tales of Eternia style.
Character: young woman, brown long hair, red light armor dress, small sword, cheerful.
LAYOUT: grid of 4 rows x 4 columns (16 cells), evenly spaced, each cell 32x48 px.
Row order: facing DOWN, UP, LEFT, RIGHT.
Column order: idle, walk-1, walk-2, walk-3.
Consistent character across all cells, transparent background.
[+ STYLE tokens] [+ NEGATIVE]
```
日本語: 上→下上左右の順、列→待機/歩1/歩2/歩3。32x48セルの4x4。

### 1-2. 女僧侶 フィールド歩行シート (`priest_field`)
```
A female priest/healer sprite sheet, same LAYOUT/grid/cell-size as the warrior sheet.
Character: young woman, dark hair, white-and-blue robe, wooden staff, gentle expression.
[same LAYOUT 4x4, 32x48] [+ STYLE] [+ NEGATIVE]
```

### 1-3. バトル用シート (`warrior_battle` / `priest_battle`)
```
A side-view battle sprite sheet for a 2D action JRPG (Tales of Eternia LMB style).
Character: <女戦士 or 女僧侶, 上と同一デザイン>, facing RIGHT.
LAYOUT: grid 2 rows x 4 columns (8 cells), evenly spaced, each cell 64x64 px.
Cells in order: idle, step-forward, attack-1, attack-2, attack-3, guard, hurt, victory.
(priest: replace attack-2/3 with cast-charge / cast-release)
[+ STYLE] [+ NEGATIVE]
```

### 1-4. 顔グラフィック / 立ち絵 (`*_face`)
```
A character portrait bust for a JRPG dialogue window, Tales of Eternia style.
Character: <キャラ説明>. Head and shoulders, facing slightly to the side.
LAYOUT: 2x2 grid of expressions (neutral, smile, angry, surprised), each 256x256 px.
[+ STYLE] [+ NEGATIVE]
```

---

## 2. 敵

### 2-1. スライム (`slime_battle` / `slime_field`)
```
A cute slime enemy sprite sheet, side-view for a 2D JRPG battle, Tales of Eternia style.
Blue translucent slime with glossy highlight and simple eyes.
LAYOUT: grid 1 row x 5 columns, each cell 64x64 px.
Cells: idle, hop-move, attack, hurt, defeat(fading).
[+ STYLE] [+ NEGATIVE]
```
フィールド用シンボルは 32x32・待機2コマで別途生成（同デザイン）。

### 2-2. ゴブリン (`goblin_battle`)
```
A goblin enemy sprite sheet, side-view battle, Tales of Eternia style.
Small green goblin with a crude dagger, mischievous.
LAYOUT: grid 1 row x 5 columns, each cell 64x64 px.
Cells: idle, move, attack, hurt, defeat.
[+ STYLE] [+ NEGATIVE]
```

### 2-3. ボス ゴーレム (`boss_golem`)
```
A large stone golem boss, side-view battle, Tales of Eternia style, imposing.
LAYOUT: grid 1 row x 5 columns, each cell 128x128 px.
Cells: idle, attack-smash, enrage, hurt, defeat(crumbling).
[+ STYLE] [+ NEGATIVE]
```

---

## 3. タイルセット / 背景

### 3-1. 町タイルセット (`town_tileset`)
```
A top-down RPG town tileset, Tales of Eternia style, anime fantasy village.
Seamless tiles on a grid, each tile 32x32 px, evenly spaced.
Include: grass, dirt path, cobblestone, stone wall, wooden house wall, red roof,
water edge, fence, flowers. Tileable/seamless edges.
[+ STYLE] [+ NEGATIVE]
```

### 3-2. フィールドタイルセット (`field_tileset`)
```
A top-down RPG overworld field tileset, anime fantasy, 32x32 tiles on a grid.
Include: grassland, dirt, rocks, tree, bush, flowers, cliff edge, path.
Seamless tileable. [+ STYLE] [+ NEGATIVE]
```

### 3-3. ダンジョンタイルセット (`dungeon_tileset`)
```
A top-down dungeon tileset, dark stone ruins, anime style, 32x32 tiles.
Include: stone floor, stone wall, wooden door, treasure chest, torch, stairs.
Seamless tileable. [+ STYLE] [+ NEGATIVE]
```

### 3-4. バトル背景 (`battle_bg_field`)
```
A side-scrolling battle background for a 2D JRPG, Tales of Eternia style.
Grassy plain with distant hills and blue sky, horizontal 640x360, no characters.
Optional parallax layers. [+ STYLE] [+ NEGATIVE]
```

---

## 4. UI

### 4-1. ウィンドウ枠 (`ui_window`)
```
A JRPG message/menu window frame, Tales of Eternia style, semi-transparent deep blue,
ornate but clean gold trim corners. Designed for 9-slice scaling (repeatable edges,
distinct corners). Transparent center. PNG. [+ NEGATIVE]
```

### 4-2. ゲージ (`ui_hpbar`)
```
A JRPG status gauge asset set: an empty bar frame plus two fill bars
(red for HP, blue for TP), clean anime UI, 9-slice friendly. Transparent bg.
[+ NEGATIVE]
```

### 4-3. ボタン (`ui_button`)
```
A JRPG UI button in 3 states (normal, hover-highlight, pressed), rounded,
blue with gold trim, anime style, transparent background. [+ NEGATIVE]
```

### 4-4. アイコン (`ui_icons`)
```
A JRPG icon sheet, 32x32 cells on a grid, flat anime style, transparent bg.
Icons: fire, water, wind, earth, light, dark, heal-cross, sword, staff, potion.
[+ NEGATIVE]
```

---

## 5. エフェクト

```
# fx_slash
A slash effect animation sprite sheet, white-blue arc, anime JRPG,
1 row x 4 columns, each 64x64 px, transparent background. [+ NEGATIVE]

# fx_heal
A green healing sparkle effect sprite sheet, 1 row x 4 columns, 64x64 cells,
transparent background, anime JRPG. [+ NEGATIVE]

# fx_fire
A fireball / fire burst effect sprite sheet, 1 row x 5 columns, 64x64 cells,
transparent background, anime JRPG. [+ NEGATIVE]
```

---

## AssetManager 運用メモ
- **セル数がプロンプト通りか必ず検品**。ズレたら列/行を指定し直すか単体生成→結合。
- 生成物は `01_asset_list.md` の想定パスへ配置し、Godot import時 Filter=Off。
- スプライトシートは Godot 側で `hframes`/`vframes`（例: 女戦士フィールド=hframes 4, vframes 4）で切り出す。
  この列数・行数を変えると Programmer 実装と食い違うので、変更時は必ず共有。
