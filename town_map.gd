extends Node2D

const SPAWN_POINT := Vector2(768, 900)
const COLLISION_MASK_PATH := "res://assets/town/elden/square_collision.png"
const COLLISION_ALPHA_THRESHOLD := 0.5
const COLLISION_POLYGON_EPSILON := 3.0
const FALLBACK_COLLISION_NAMES := [
	"TopSceneryCollision",
	"LeftSceneryCollision",
	"RightSceneryCollision",
	"LeftPondCollision",
	"RightPondCollision",
	"LeftEdgeCollision",
	"RightEdgeCollision",
	"BottomEdgeCollision",
]

func _ready() -> void:
	_setup_mask_collisions()

func get_spawn_point() -> Vector2:
	return SPAWN_POINT

func _setup_mask_collisions() -> void:
	if not FileAccess.file_exists(COLLISION_MASK_PATH):
		return

	var image := _load_collision_image()
	if image.is_empty():
		push_warning("Unable to load town collision mask: %s" % COLLISION_MASK_PATH)
		return

	var bitmap := BitMap.new()
	bitmap.create_from_image_alpha(image, COLLISION_ALPHA_THRESHOLD)
	var bounds := Rect2(Vector2.ZERO, image.get_size())
	var polygons: Array[PackedVector2Array] = bitmap.opaque_to_polygons(
		bounds,
		COLLISION_POLYGON_EPSILON
	)
	if polygons.is_empty():
		push_warning("Town collision mask contains no opaque polygons: %s" % COLLISION_MASK_PATH)
		return

	_remove_fallback_collisions()
	for index in polygons.size():
		var body := StaticBody2D.new()
		body.name = "MaskCollision%d" % index
		body.collision_layer = 1
		body.collision_mask = 1

		var collision := CollisionPolygon2D.new()
		collision.polygon = polygons[index]
		body.add_child(collision)
		add_child(body)

func _load_collision_image() -> Image:
	var texture := load(COLLISION_MASK_PATH) as Texture2D
	if texture:
		return texture.get_image()

	var image := Image.new()
	if image.load(COLLISION_MASK_PATH) == OK:
		return image
	return Image.new()

func _remove_fallback_collisions() -> void:
	for node_name in FALLBACK_COLLISION_NAMES:
		var node := get_node_or_null(node_name)
		if node:
			node.queue_free()
