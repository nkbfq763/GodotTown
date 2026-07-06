extends Control

@onready var warrior_button = $WarriorButton
@onready var priest_button = $PriestButton

func _ready() -> void:
	warrior_button.pressed.connect(_on_warrior_selected)
	priest_button.pressed.connect(_on_priest_selected)

func _on_warrior_selected() -> void:
	var warrior_data := CharacterData.new()
	warrior_data.character_name = "女戦士"
	warrior_data.character_type = "warrior"
	warrior_data.speed = 160.0
	warrior_data.health = 120
	warrior_data.attack = 15
	_start_game(warrior_data)

func _on_priest_selected() -> void:
	var priest_data := CharacterData.new()
	priest_data.character_name = "女僧侶"
	priest_data.character_type = "priest"
	priest_data.speed = 140.0
	priest_data.health = 80
	priest_data.attack = 8
	_start_game(priest_data)

func _start_game(data: CharacterData) -> void:
	GameData.set_character_data(data)
	get_tree().change_scene_to_file("res://main.tscn")
