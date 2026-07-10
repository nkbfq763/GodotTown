extends CanvasLayer

var character: CharacterData
var hp_bar: ProgressBar
var tp_bar: ProgressBar
var gald_label: Label

func _ready() -> void:
	hp_bar = $Panel/HP
	tp_bar = $Panel/TP
	gald_label = $Panel/Gald
	set_character(GameData.get_character_data())

func set_character(data: CharacterData) -> void:
	character = data
	if not character:
		return
	character.reset_for_battle()
	hp_bar.max_value = character.health
	tp_bar.max_value = character.max_tp
	_refresh()

func _process(_delta: float) -> void:
	_refresh()

func _refresh() -> void:
	if not character:
		return
	hp_bar.value = character.current_hp
	tp_bar.value = character.current_tp
	gald_label.text = "Gald: %d" % GameData.gald
