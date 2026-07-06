extends Node2D

@onready var town_map: Node2D = $TownMap
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if town_map.has_method("get_spawn_point"):
		player.global_position = town_map.get_spawn_point()
