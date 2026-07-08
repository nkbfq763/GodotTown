extends Node
## ゲーム全体の状態管理とシーン遷移を担うシングルトン（autoload: GameManager）

const TITLE_SCENE := "res://scenes/title/title.tscn"
const TOWN_SCENE := "res://scenes/town/town.tscn"


func goto_town() -> void:
	change_scene(TOWN_SCENE)


func goto_title() -> void:
	change_scene(TITLE_SCENE)


func change_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)
