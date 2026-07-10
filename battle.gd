extends Node2D

enum State { START, PLAYER_TURN, RESULT }
var state := State.START
var hero: CharacterData
var enemies: Array[Dictionary] = []
var result_label: Label
var status_label: Label

func _ready() -> void:
	hero = GameData.get_character_data()
	if not hero:
		hero = load("res://data/hero.tres")
		GameData.set_character_data(hero)
	hero.reset_for_battle()
	for data in GameData.pending_encounter:
		enemies.append({"data": data, "hp": data.max_hp})
	result_label = $Result
	status_label = $Status
	state = State.PLAYER_TURN
	_refresh_display()

func _unhandled_input(event: InputEvent) -> void:
	if state == State.PLAYER_TURN and event.is_action_pressed("ui_accept"):
		_attack()
	elif state == State.RESULT and event.is_action_pressed("ui_accept"):
		if GameData.battle_won:
			get_tree().change_scene_to_file("res://field.tscn")
		else:
			get_tree().change_scene_to_file("res://title.tscn")

func _physics_process(_delta: float) -> void:
	if state != State.PLAYER_TURN:
		return
	var direction := Input.get_axis("ui_left", "ui_right")
	$Hero.position.x = clampf($Hero.position.x + direction * 3.0, 80.0, 260.0)

func _attack() -> void:
	for enemy in enemies:
		if enemy.hp > 0:
			var defender: EnemyData = enemy.data
			var damage := maxi(1, int(hero.attack * 1.0) - defender.defense)
			enemy.hp = maxi(0, enemy.hp - damage)
			status_label.text = "%s attacks %s for %d damage!" % [hero.character_name, defender.enemy_name, damage]
			break
	if _all_defeated():
		_win()
	else:
		_enemy_turn()
	_refresh_display()

func _enemy_turn() -> void:
	for enemy in enemies:
		if enemy.hp > 0:
			var attacker: EnemyData = enemy.data
			var damage := maxi(1, attacker.attack - hero.defense)
			hero.current_hp = maxi(0, hero.current_hp - damage)
			status_label.text += "  %s hits Roland for %d." % [attacker.enemy_name, damage]
			if hero.current_hp == 0:
				state = State.RESULT
				GameData.finish_battle(false)
				result_label.text = "Defeat\nPress Enter to return to title"
			break

func _all_defeated() -> bool:
	for enemy in enemies:
		if enemy.hp > 0:
			return false
	return true

func _win() -> void:
	state = State.RESULT
	var reward := 0
	for enemy in enemies:
		reward += enemy.data.gald
	GameData.gald += reward
	GameData.finish_battle(true)
	result_label.text = "Victory!  +%d Gald\nPress Enter to return" % reward

func _refresh_display() -> void:
	for index in enemies.size():
		var enemy_label: Label = $EnemyList.get_child(index)
		enemy_label.text = "%s  HP %d/%d" % [enemies[index].data.enemy_name, enemies[index].hp, enemies[index].data.max_hp]
