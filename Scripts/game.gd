extends Node2D

class_name game_manager
signal game_won

func _ready():
	RandomUtils.set_seed(0)
	var entities: entities_manager = $/root/GameManager/Entities
	entities.level_complete.connect(_on_next_level)
	var restart_button: Button = $/root/GameManager/UI/UIContainer/MiddleContainer/MenuContainer/RestartButton
	restart_button.pressed.connect(_restart)
	var quit_button: Button = $/root/GameManager/UI/UIContainer/MiddleContainer/MenuContainer/QuitButton
	quit_button.pressed.connect(func(): get_tree().quit())

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_ESCAPE:
			_restart();

func _on_next_level():
	call_deferred("_next_level")

func _next_level():
	if (GameVariable.level >= 9):
		game_won.emit()
	else:
		GameVariable.width += 1
		GameVariable.height += 1
		GameVariable.level += 1
		get_tree().reload_current_scene()

func _restart():
	GameVariable.width = 5
	GameVariable.height = 1
	GameVariable.level = 0
	randomize()
	get_tree().reload_current_scene()
