extends Node

class_name entities_manager

signal target_count_changed(current: int, total: int)
signal level_complete()
signal no_movement_started()
signal no_movement_ended()
signal no_movement_warning()

var maze: MazeUtils.Maze
var n_target: int
var d_target: int = 0
var size: Vector2
var width: int
var height: int
@export var maze_thickness: float = 10.0
@export var wall_length: float = 50.0
@export var start_height: float = 100.0
var start_width: float
@export var cell_selection: MazeUtils.CELL_SELECTION = MazeUtils.CELL_SELECTION.RANDOM
var target_indexes: Array
@export var intensity: float = 0.1
var light_timer: Timer
var player: CharacterBody2D

func _ready():
	width = GameVariable.width
	height = GameVariable.height
	maze = MazeUtils.generate(width, height, cell_selection)
	target_indexes = MazeUtils.get_random_cells(maze, intensity)
	n_target = target_indexes.size()

	size = get_viewport().get_visible_rect().size
	start_width = size.x/2 - maze.width * wall_length / 2
	player = $Player
	player.position = Vector2(start_width + wall_length/ 2, start_height + wall_length/ 2)

	var x: int = 0
	var y: int = 0
	for target_index: int in target_indexes:
		x = target_index % maze.width
		y = target_index / maze.width

		var target = load("res://Scenes/Target.tscn").instantiate()
		add_child(target)
		target.position = Vector2(
			start_width + x * wall_length + wall_length / 2,
			start_height + y * wall_length + wall_length / 2
		)
		target.target_hit.connect(_on_target_hit);

	target_count_changed.emit(d_target, n_target)
	create_maze()

	$EvilTimer.timeout.connect(_on_evil_timeout)
	light_timer = $InLightTimer
	light_timer.timeout.connect(_on_light_timeout)
	light_timer.one_shot = true

func _on_evil_timeout():
	var evil = load("res://Scenes/Evil.tscn").instantiate()
	add_child(evil)
	evil.body_entered.connect(_on_evil_body_entered)
	evil.body_exited.connect(_on_evil_body_exited)

func _on_light_timeout():
	no_movement_started.emit()

func _on_target_hit():
	d_target += 1
	target_count_changed.emit(d_target, n_target)
	if d_target >= n_target:
		level_complete.emit()

func _on_evil_body_entered(body: Node2D):
	if body is CharacterBody2D:
		no_movement_warning.emit()
		light_timer.start(1.0)

func _on_evil_body_exited(body: Node2D):
	if body is CharacterBody2D:
		no_movement_warning.emit()
		no_movement_ended.emit()
		light_timer.stop()

func create_physics_wall(start: Vector2, end: Vector2, thickness: float):
	var wall: StaticBody2D = load("res://Scenes/Wall.tscn").instantiate()
	var wall_size: Vector2
	var wall_center: Vector2
	
	if start.x == end.x: # Vertical
		wall_size = Vector2(thickness, abs(end.y - start.y))
		wall_center = Vector2(start.x, (start.y + end.y) / 2)
	else: # Horizontal
		wall_size = Vector2(abs(end.x - start.x), thickness)
		wall_center = Vector2((start.x + end.x) / 2, start.y)

	wall.position = wall_center
	var wall_collision: CollisionShape2D = wall.get_node("CollisionShape2D")
	var new_shape: RectangleShape2D = RectangleShape2D.new();
	new_shape.size = wall_size;
	wall_collision.shape = new_shape;

	var wall_color: ColorRect = wall.get_node("ColorRect");
	wall_color.size = wall_size;
	wall_color.position = - wall_size / 2;

	add_child(wall);

func create_maze():
	var x: int = 0
	var y: int = 0
	var cell: int = 0
	var start_x: float = 0.0
	var start_y: float = 0.0
	for i: int in maze.grid.size():
		x = i % maze.width;
		y = i / maze.width;
		cell = maze.grid[i];

		if MazeUtils.is_wall_north(cell):
			start_x = start_width + x * wall_length - maze_thickness / 2;
			start_y = start_height + y * wall_length;
			create_physics_wall(
				Vector2(start_x, start_y), 
				Vector2(start_x + wall_length + maze_thickness, start_y), 
				maze_thickness
			);

		if MazeUtils.is_wall_south(cell):
			start_x = start_width + x * wall_length - maze_thickness / 2;
			start_y = start_height + y * wall_length + wall_length;
			create_physics_wall(
				Vector2(start_x, start_y), 
				Vector2(start_x + wall_length + maze_thickness, start_y), 
				maze_thickness
			);

		if MazeUtils.is_wall_east(cell):
			start_x = start_width + x * wall_length + wall_length;
			start_y = start_height + y * wall_length;
			create_physics_wall(
				Vector2(start_x, start_y),
				Vector2(start_x, start_y + wall_length), 
				maze_thickness
			);

		if MazeUtils.is_wall_west(cell):
			start_x = start_width + x * wall_length;
			start_y = start_height + y * wall_length;
			create_physics_wall(
				Vector2(start_x, start_y), 
				Vector2(start_x, start_y + wall_length), 
				maze_thickness
			);
