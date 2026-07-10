extends Resource
class_name EnemyData

@export var enemy_name: String
@export var max_hp: int = 30
@export var attack: int = 5
@export var defense: int = 0
@export var exp: int = 5
@export var gald: int = 3
@export_file("*.png") var battle_sprite: String = "res://assets/enemies/slime/battle.png"
