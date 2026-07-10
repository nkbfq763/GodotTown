extends Node2D

@onready var town_map: Node2D = $TownMap
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if not GameData.get_character_data():
		GameData.set_character_data(load("res://data/hero.tres"))
	if town_map.has_method("get_spawn_point"):
		player.global_position = town_map.get_spawn_point()

func _on_field_exit_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file("res://field.tscn")
