extends Node2D
## 拠点となる町マップ。
## Kenney Tiny Town タイルセット（CC0）から TileMapLayer を実行時に構築する。
## レイアウトはコード内のデータで定義する（docs/03_asset_generation.md A3 参照）。

const TILESET_TEXTURE := "res://assets/tilesets/kenney_tiny_town/tilemap_packed.png"
const SOURCE_TILE := 16
const TILE_SCALE := 2
const TILE := SOURCE_TILE * TILE_SCALE  # ワールド上のタイルサイズ (32px)

const MAP_W := 40
const MAP_H := 30

# アトラス座標 (col, row)
const GRASS_VARIANTS: Array[Vector2i] = [
	Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0),
	Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0),
	Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0),
	Vector2i(0, 0), Vector2i(0, 0),
	Vector2i(1, 0), Vector2i(2, 0),
]
const DIRT := Vector2i(1, 2)
const STONE := Vector2i(7, 3)
const TREE_GREEN := Vector2i(4, 2)
const TREE_YELLOW := Vector2i(3, 2)
const MUSHROOM := Vector2i(5, 2)

# 家パターン (3x3): 屋根2段 + 壁1段（中央にドア）
const HOUSE_RED: Array = [
	[Vector2i(4, 4), Vector2i(5, 4), Vector2i(6, 4)],
	[Vector2i(4, 5), Vector2i(5, 5), Vector2i(6, 5)],
	[Vector2i(0, 6), Vector2i(1, 7), Vector2i(0, 6)],
]
const HOUSE_GRAY: Array = [
	[Vector2i(0, 4), Vector2i(1, 4), Vector2i(2, 4)],
	[Vector2i(0, 5), Vector2i(1, 5), Vector2i(2, 5)],
	[Vector2i(4, 6), Vector2i(5, 7), Vector2i(4, 6)],
]

# 家の配置: [左上タイル座標, パターン]
const HOUSES: Array = [
	[Vector2i(6, 5), "red"],
	[Vector2i(14, 4), "gray"],
	[Vector2i(26, 5), "red"],
	[Vector2i(7, 19), "gray"],
	[Vector2i(15, 22), "red"],
	[Vector2i(27, 20), "gray"],
]

const PLAZA := Rect2i(16, 11, 8, 7)     # 中央広場（石畳）
const ROAD_V := Rect2i(19, 3, 2, 27)    # 南北の道（南端が町の出口）
const ROAD_H := Rect2i(4, 14, 33, 2)    # 東西の道

const SPAWN_TILE := Vector2(20, 15)

const SCATTERED_TREES: Array[Vector2i] = [
	Vector2i(4, 3), Vector2i(11, 8), Vector2i(31, 3), Vector2i(35, 9),
	Vector2i(3, 24), Vector2i(12, 26), Vector2i(24, 25), Vector2i(34, 24),
	Vector2i(10, 11), Vector2i(30, 12), Vector2i(9, 16), Vector2i(31, 17),
]

@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	var tile_set := _build_tile_set()
	var ground := _make_layer("Ground", tile_set, 0)
	var objects := _make_layer("Objects", tile_set, 1)
	_paint_ground(ground)
	_paint_objects(objects)
	_build_collisions()
	_setup_player()


func _build_tile_set() -> TileSet:
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(SOURCE_TILE, SOURCE_TILE)
	var source := TileSetAtlasSource.new()
	source.texture = load(TILESET_TEXTURE)
	source.texture_region_size = Vector2i(SOURCE_TILE, SOURCE_TILE)
	var grid := (source.texture.get_size() / SOURCE_TILE).floor()
	for x in range(int(grid.x)):
		for y in range(int(grid.y)):
			source.create_tile(Vector2i(x, y))
	tile_set.add_source(source, 0)
	return tile_set


func _make_layer(layer_name: String, tile_set: TileSet, z: int) -> TileMapLayer:
	var layer := TileMapLayer.new()
	layer.name = layer_name
	layer.tile_set = tile_set
	layer.scale = Vector2(TILE_SCALE, TILE_SCALE)
	layer.z_index = z
	layer.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(layer)
	return layer


func _paint_ground(ground: TileMapLayer) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 12345
	for x in range(MAP_W):
		for y in range(MAP_H):
			var coords := GRASS_VARIANTS[rng.randi() % GRASS_VARIANTS.size()]
			ground.set_cell(Vector2i(x, y), 0, coords)
	_fill_rect(ground, ROAD_V, DIRT)
	_fill_rect(ground, ROAD_H, DIRT)
	_fill_rect(ground, PLAZA, STONE)


func _paint_objects(objects: TileMapLayer) -> void:
	for entry in HOUSES:
		var origin: Vector2i = entry[0]
		var pattern: Array = HOUSE_RED if entry[1] == "red" else HOUSE_GRAY
		for row in range(pattern.size()):
			for col in range(pattern[row].size()):
				objects.set_cell(origin + Vector2i(col, row), 0, pattern[row][col])
	for pos in _border_tree_cells():
		objects.set_cell(pos, 0, TREE_GREEN)
	for i in range(SCATTERED_TREES.size()):
		var coords := TREE_YELLOW if i % 3 == 0 else TREE_GREEN
		objects.set_cell(SCATTERED_TREES[i], 0, coords)
	objects.set_cell(Vector2i(13, 10), 0, MUSHROOM)
	objects.set_cell(Vector2i(25, 19), 0, MUSHROOM)


func _border_tree_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for x in range(MAP_W):
		cells.append(Vector2i(x, 0))
		# 南端は道の部分（町の出口）を空けておく
		if not ROAD_V.has_point(Vector2i(x, MAP_H - 1)):
			cells.append(Vector2i(x, MAP_H - 1))
	for y in range(1, MAP_H - 1):
		cells.append(Vector2i(0, y))
		cells.append(Vector2i(MAP_W - 1, y))
	return cells


func _build_collisions() -> void:
	for entry in HOUSES:
		var origin: Vector2i = entry[0]
		_add_collision_rect(Rect2i(origin.x, origin.y + 1, 3, 2))
	for pos in _border_tree_cells():
		_add_collision_rect(Rect2i(pos, Vector2i(1, 1)))
	for pos in SCATTERED_TREES:
		_add_collision_rect(Rect2i(pos, Vector2i(1, 1)))


func _add_collision_rect(tile_rect: Rect2i) -> void:
	var body := StaticBody2D.new()
	body.collision_layer = 1
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(tile_rect.size) * TILE
	shape.shape = rect
	body.position = (Vector2(tile_rect.position) + Vector2(tile_rect.size) * 0.5) * TILE
	body.add_child(shape)
	add_child(body)


func _setup_player() -> void:
	player.global_position = SPAWN_TILE * TILE
	player.z_index = 1
	var camera: Camera2D = player.get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = MAP_W * TILE
	camera.limit_bottom = MAP_H * TILE


func _fill_rect(layer: TileMapLayer, rect: Rect2i, coords: Vector2i) -> void:
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			layer.set_cell(Vector2i(x, y), 0, coords)
