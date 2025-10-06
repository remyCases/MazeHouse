extends VBoxContainer

var menu_text: Label
var game: game_manager
var entities: entities_manager
var player: player_manager

func _ready():
	visible = false
	menu_text = get_child(0)
	game = $/root/GameManager
	entities = $/root/GameManager/Entities
	player = $/root/GameManager/Entities/Player
	game.game_won.connect(_on_game_won)
	player.game_lost.connect(_on_game_lost)

func _on_game_won():
	visible = !visible
	entities.queue_free();
	menu_text.text = "You Won !!"

func _on_game_lost():
	visible = !visible
	entities.queue_free();
	menu_text.text = "Try Again ?"
