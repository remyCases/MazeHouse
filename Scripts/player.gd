extends CharacterBody2D

class_name player_manager
signal game_lost

@export var speed: int = 150
var input_direction: Vector2
var flag_no_movement_checker: bool = false

func _ready():
	var entities: entities_manager = get_node("/root/GameManager/Entities");
	entities.no_movement_started.connect(func(): set_flag(true))
	entities.no_movement_ended.connect(func(): set_flag(false))

func get_input():
	input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");

func _physics_process(_delta: float):
	get_input()
	if (flag_no_movement_checker && input_direction.length() > 0.5):
		game_lost.emit()

	velocity = input_direction * speed
	move_and_slide();

func set_flag(new_flag: bool):
	flag_no_movement_checker = new_flag
