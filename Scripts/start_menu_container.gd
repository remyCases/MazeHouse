extends VBoxContainer

@export var start_button: Button
@export var quit_button: Button

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
