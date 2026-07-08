# アセット生成方法の検討（無料アセット / 無料AI生成）

各アセットについて「推奨手段」と「代替手段」、AI 生成の場合は**そのまま使えるプロンプト**を用意する。
方針: **まず実績ある無料アセットで動くものを作り、独自の見た目が欲しい箇所だけ AI 生成で差し替える**。

---

## A1. 町タイルセット（地面・道・建物・木・水）

### 推奨: 無料アセット（最も品質が安定、ライセンスも安全）

| 素材 | ライセンス | URL |
|---|---|---|
| Kenney「Tiny Town」(16x16) | CC0（クレジット不要・商用可） | https://kenney.nl/assets/tiny-town |
| Kenney「Roguelike/RPG pack」 | CC0 | https://kenney.nl/assets/roguelike-rpg-pack |
| Cute Fantasy RPG (16x16) | 無料版あり（クレジット表記） | https://kenmi-art.itch.io/cute-fantasy-rpg |
| Pixel Art Top Down - Basic | 無料 | https://cainos.itch.io/pixel-art-top-down-basic |

→ **P1 では Kenney Tiny Town（CC0）を採用**。Devin がダウンロードして TileSet 化まで実施可能。

### 代替: AI 生成（Gemini / Copilot / Grok の画像生成）

タイルセットはシームレス性が必要で AI 生成の難易度が高い。使う場合は「1 タイルずつ」生成が現実的。

**プロンプト例（Gemini / Copilot 画像生成に貼り付け）:**

```
Generate a pixel art tileset for a top-down 2D RPG town, 16x16 pixel tiles
arranged in a single sprite sheet on a transparent background.
Include: grass, dirt road, stone path, water, house wall (wood), house roof
(red tile), door, window, fence, tree, bush, flowers.
Style: bright fantasy JRPG, SNES era, consistent palette of about 24 colors,
no anti-aliasing, crisp pixel edges, grid-aligned.
```

日本語版:
```
2DトップダウンRPGの町用ピクセルアートタイルセットを生成してください。
16x16ピクセルのタイルを1枚のスプライトシートに格子状に並べ、背景は透過。
含めるもの: 草地、土の道、石畳、水面、木造の家の壁、赤い瓦屋根、ドア、窓、柵、木、茂み、花。
スタイル: 明るいファンタジーJRPG風、スーパーファミコン時代のドット絵、
約24色の統一パレット、アンチエイリアスなし、グリッドに揃えること。
```

---

## A2. 主人公（女性）スプライトシート（4方向歩行）

### 推奨①: 無料キャラ生成ツール（歩行アニメ付きで確実）

- **Universal LPC Spritesheet Generator**（無料・ブラウザ上で女性キャラの外見をパーツ合成、4方向歩行アニメ付き）
  https://liberatedpixelcup.github.io/Universal-LPC-Spritesheet-Character-Generator/
  ライセンス: CC-BY-SA / GPL（クレジット表記必要、生成画面にクレジット一覧が出る）
- 和風JRPG寄りなら「ぴぽや倉庫」の無料キャラチップ https://pipoya.net/sozai/

### 推奨②: AI 生成（無料枠で可能）

- **PixelLab** (https://www.pixellab.ai/) : ドット絵キャラ＋歩行アニメ生成に特化、無料枠あり
- **Gemini / Copilot / Grok**: 静止画は得意だがスプライトシートの整列が崩れやすい → 生成後に手動整列（Devin が画像処理で補正可能）

**プロンプト例（歩行スプライトシート）:**

```
Create a pixel art character sprite sheet for a 2D top-down JRPG.
Character: a young female adventurer / princess with long blonde hair,
blue and white dress, brown boots.
Layout: 4 rows x 3 columns on a transparent background.
Row 1: walking down (front view), Row 2: walking left,
Row 3: walking right, Row 4: walking up (back view).
Each frame exactly 32x48 pixels, feet aligned to the bottom of each cell,
consistent proportions across all frames.
Style: SNES-era JRPG pixel art, no anti-aliasing, clean outlines.
```

日本語版:
```
2DトップダウンJRPG用の主人公スプライトシートをドット絵で作成してください。
キャラクター: 金髪ロングの若い女性冒険者（姫騎士風）、青と白のドレス、茶色のブーツ。
レイアウト: 透過背景に4行×3列。
1行目=正面歩き、2行目=左向き歩き、3行目=右向き歩き、4行目=後ろ向き歩き。
各コマは32x48ピクセルで、足の位置を各セルの下端に揃え、全コマで頭身を統一すること。
スタイル: スーパーファミコン風JRPGドット絵、アンチエイリアスなし、輪郭線くっきり。
```

### 立ち絵・イベントCG（P5 以降で使用）

Violated Princess 調のイベント絵はアニメ調立ち絵。無料 AI では以下が候補:
- Gemini（Imagen）/ Copilot（DALL-E）/ Grok: アニメ調立ち絵は無料枠で生成可
- プロンプト例:
```
Anime-style full body standing illustration of a young princess adventurer,
long blonde hair, blue and white dress, gentle expression, transparent
background, visual novel character sprite, high quality anime art.
```

---

## A3. 町マップデータ（.tscn / TileMap）

- **推奨: Devin / Godot エディタで作成**。TileMapLayer にタイルを配置するのはデータ作業なので、Devin が GDScript（エディタスクリプト or シーンファイル直接生成）で自動配置可能
- 代替: **Tiled Map Editor**（無料 https://www.mapeditor.org/）で編集し、アドオン「YATI (Yet Another Tiled Importer)」で Godot に取り込む
- AI 活用: マップのレイアウト案（どこに家・広場・出口を置くか）を LLM に ASCII で出させ、それを Devin がタイル配置に変換する運用が可能

**レイアウト生成プロンプト例:**
```
40x30 タイルのRPGの町マップレイアウトをASCIIで設計してください。
記号: G=草, R=道, H=家, W=水, T=木, F=柵, E=町の出口(南), S=主人公スポーン地点。
中央に広場、北に大きな屋敷、東西に民家、南に町の出口を配置してください。
```

## A4. タイトル背景・ロゴ

- AI 生成が最適（1枚絵なので破綻しにくい）。Gemini / Copilot 無料枠で生成
```
Fantasy JRPG title screen background: a peaceful medieval town at sunset
seen from a hill, warm colors, anime background art style, no text, 16:9.
```
- ロゴ文字は Godot の Label + 無料フォントで十分（画像化不要）

## A5. BGM（町の曲）

| 手段 | 備考 |
|---|---|
| **魔王魂** https://maou.audio/ | 無料・商用可（クレジット表記）、JRPG向け曲が豊富 → **推奨** |
| DOVA-SYNDROME https://dova-s.jp/ | 無料、曲数最大級 |
| Kenney Music | CC0 |
| Suno AI https://suno.com/ | 無料枠あり。プロンプト例: 「peaceful medieval fantasy town theme, orchestral, flute and strings, loopable, JRPG style」 |

## A6. 効果音（足音・決定音）

- **効果音ラボ** https://soundeffect-lab.info/ （無料・クレジット不要）→ 推奨
- Kenney Audio（CC0） https://kenney.nl/assets?q=audio

## A7. フォント・UI

- **PixelMplus**（無料・日本語ドット絵フォント） https://itouhiro.hatenablog.com/entry/20130602/font
- UI ウィンドウ枠は Godot の Theme + NinePatchRect で自作（画像が要る場合は Kenney UI Pack: CC0）

---

## ライセンス上の注意

- CC0（Kenney）: 表記不要・改変自由 → 最優先で採用
- CC-BY / 独自ライセンス素材: `docs/CREDITS.md` を作りクレジットを必ず記録する
- AI 生成物: 各サービスの利用規約を確認（Gemini/Copilot 生成画像は商用利用可だが規約変更に注意）。生成に使ったプロンプトも記録しておく

## P1 での結論（採用方針まとめ)

| アセット | P1 での採用手段 |
|---|---|
| タイルセット | Kenney Tiny Town（CC0、Devin がDL・TileSet化） |
| 主人公スプライト | Universal LPC Generator または PixelLab（後で AI 生成版に差し替え可） |
| 町マップ | Devin が GDScript/tscn で配置 |
| タイトル背景 | AI 生成（Gemini 等、上記プロンプト） |
| BGM/SE | 魔王魂 + 効果音ラボ（任意、P1では省略可） |
| フォント | PixelMplus |
