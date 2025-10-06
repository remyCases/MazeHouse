extends Area2D

signal target_hit

func _ready():
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(_body: Node2D):
	target_hit.emit()
	queue_free();
