extends CharacterBody2D
## 主人公（女性）。LPC 形式のスプライトシートから 4 方向歩行アニメを構築する。

const SPRITE_SHEET := "res://assets/characters/heroine/heroine_walk.png"
const FRAME_SIZE := Vector2i(64, 64)
const WALK_FRAMES := 8  # 各行: 0 = 立ち, 1..8 = 歩行
# LPC 標準の行順: 0 = 上, 1 = 左, 2 = 下, 3 = 右
const ROW_BY_DIR := {"up": 0, "left": 1, "down": 2, "right": 3}

@export var speed := 120.0

var _facing := "down"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.sprite_frames = _build_sprite_frames()
	sprite.play("idle_down")


func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input * speed
	move_and_slide()
	_update_animation(input)


func _update_animation(input: Vector2) -> void:
	if input == Vector2.ZERO:
		sprite.play("idle_" + _facing)
		return
	if absf(input.x) >= absf(input.y):
		_facing = "right" if input.x > 0.0 else "left"
	else:
		_facing = "down" if input.y > 0.0 else "up"
	sprite.play("walk_" + _facing)


func _build_sprite_frames() -> SpriteFrames:
	var texture: Texture2D = load(SPRITE_SHEET)
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	for dir in ROW_BY_DIR:
		var row: int = ROW_BY_DIR[dir]
		frames.add_animation("idle_" + dir)
		frames.set_animation_loop("idle_" + dir, true)
		frames.add_frame("idle_" + dir, _make_frame(texture, 0, row))
		frames.add_animation("walk_" + dir)
		frames.set_animation_loop("walk_" + dir, true)
		frames.set_animation_speed("walk_" + dir, 10.0)
		for i in range(1, WALK_FRAMES + 1):
			frames.add_frame("walk_" + dir, _make_frame(texture, i, row))
	return frames


func _make_frame(texture: Texture2D, col: int, row: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(col * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
	return atlas
