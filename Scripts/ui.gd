extends CanvasLayer

@export var score_label: Label
@export var information_label: Label

func _ready():
	information_label.text = "DO NOT MOVE !!";

	var entities: entities_manager = $/root/GameManager/Entities
	entities.target_count_changed.connect(_on_target_count_changed)
	entities.no_movement_warning.connect(_on_no_movement_warning)

func _on_target_count_changed(current: int, total: int):
	score_label.text = "Targets: %s/%s" % [current, total]

func _on_no_movement_warning():
	information_label.visible = !information_label.visible;
