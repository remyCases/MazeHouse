extends Node
class_name MazeUtils

enum CELL_SELECTION
{
	RANDOM,
	NEWEST,
	MIDDLE,
	OLDEST,
	CHAOS,
}
enum DIRECTION
{
	N = 1,
	S = 2,
	W = 4,
	E = 8,
}
static func directions() -> Array[DIRECTION]:
	var dirs: Array[DIRECTION] = [DIRECTION.N, DIRECTION.S, DIRECTION.W, DIRECTION.E]
	RandomUtils.fydk_shuffling(dirs)
	return dirs

static func dir_x(direction: DIRECTION) -> int:
	if (direction == DIRECTION.N || direction == DIRECTION.S):
		return 0
	elif (direction == DIRECTION.W):
		return -1
	elif (direction == DIRECTION.E):
		return 1

	push_error("dir_x failed with input %s" % direction)
	return 0

static func dir_y(direction: DIRECTION) -> int:
	if (direction == DIRECTION.E || direction == DIRECTION.W):
		return 0
	elif (direction == DIRECTION.N):
		return -1
	elif (direction == DIRECTION.S):
		return 1
	
	push_error("dir_y failed with input %s" % direction)
	return 0

static func opposite(direction: DIRECTION) -> DIRECTION:
	match (direction):
		DIRECTION.E:
			return DIRECTION.W
		DIRECTION.W:
			return DIRECTION.E
		DIRECTION.N:
			return DIRECTION.S
		DIRECTION.S:
			return DIRECTION.N
	
	push_error("opposite failed with input %s" % direction)
	return DIRECTION.N

static func is_wall_north(cell_flag: int) -> bool:
	return (cell_flag & DIRECTION.N) == 0
static func is_wall_south(cell_flag: int) -> bool:
	return (cell_flag & DIRECTION.S) == 0
static func is_wall_east(cell_flag: int) -> bool:
	return (cell_flag & DIRECTION.E) == 0
static func is_wall_west(cell_flag: int) -> bool:
	return (cell_flag & DIRECTION.W) == 0

class Cell:
	var x: int
	var y: int
	
	func _init(new_x: int, new_y: int):
		x = new_x
		y = new_y

class Maze:
	var cells: Array[Cell]
	var grid: Array[int]
	var width: int
	var height: int
	var selection: CELL_SELECTION

	func _init(new_width: int, new_height: int, new_selection: CELL_SELECTION) -> void:
		width = new_width
		height = new_height
		selection = new_selection
		cells = []
		grid = []
		grid.resize(width*height)

	func get_grid(x: int, y: int) -> int:
		if (x < 0 || y < 0 || x >= width || y >= height):
			push_error("get_grid out of bound with input %s, %s" % [x, y])
			return 0
		return grid[x + y*width]
	func set_grid(x: int, y: int, value: int):
		if (x < 0 || y < 0 || x >= width || y >= height):
			push_error("set_grid out of bound with input %s, %s" % [x, y])
			return 0
		grid[x + y*width] = value
	func add_grid(x: int, y: int, dir: DIRECTION):
		if (x < 0 || y < 0 || x >= width || y >= height):
			push_error("add_grid out of bound with input %s, %s" % [x, y])
			return 0
		grid[x + y*width] |= dir

# based on https://weblog.jamisbuck.org/2011/1/27/maze-generation-growing-tree-algorithm
static func generate(width: int, height: int, selection: CELL_SELECTION):
	var maze := Maze.new(width, height, selection)
	var rand_x: int = RandomUtils.rand_int(maze.width)
	var rand_y: int = RandomUtils.rand_int(maze.height)
	var index: int = -1
	var nx: int
	var ny: int
	maze.cells.append(Cell.new(rand_x, rand_y))

	while maze.cells.size() != 0:
		index = get_next_cell(maze.cells.size(), maze.selection)
		var c: Cell = maze.cells[index]
		for dir: DIRECTION in directions():
			nx = c.x + dir_x(dir)
			ny = c.y + dir_y(dir)
			if (
				nx >= 0 && ny >= 0 && 
				nx < maze.width && ny < maze.height && 
				maze.get_grid(nx, ny) == 0
			):
				maze.add_grid(c.x, c.y, dir)
				maze.add_grid(nx, ny, opposite(dir))
				var nc := Cell.new(nx, ny)
				maze.cells.append(nc)
				index = -1
				break

		if index != -1:
			maze.cells.remove_at(index);

	return maze

static func get_random_cells(maze: Maze, intensity: float) -> Array:
	var n: int = RandomUtils.poisson_sampling(intensity*maze.width*maze.height) + 1
	return RandomUtils.selection_sampling(range(1, maze.grid.size()), n)

static func get_next_cell(n: int, cell_selection: CELL_SELECTION) -> int:
	match (cell_selection):
		CELL_SELECTION.RANDOM:
			return RandomUtils.rand_int(n)
		CELL_SELECTION.NEWEST:
			return n-1
		CELL_SELECTION.MIDDLE:
			return n/2
		CELL_SELECTION.OLDEST:
			return 0
		CELL_SELECTION.CHAOS:
			var random_selector: int = RandomUtils.rand_int(4)
			if (random_selector == 0): return RandomUtils.rand_int(n)
			if (random_selector == 1): return n-1
			if (random_selector == 2): return n/2
			return 0

	push_error("get_next_cell failed with input %s, %s" % [n, cell_selection])
	return 0
