extends Node

var friendly_pf: AStarGrid2D
var enemy_pf: AStarGrid2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# wipe the pathfinders
	friendly_pf = AStarGrid2D.new()
	enemy_pf = AStarGrid2D.new()

func initialize(width: int, height: int, cellsize: Vector2i):
	friendly_pf.region = Rect2i(0, 0, width, height)
	friendly_pf.cell_size = cellsize
	friendly_pf.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	friendly_pf.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	friendly_pf.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	friendly_pf.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	friendly_pf.jumping_enabled = false
	friendly_pf.update()

	enemy_pf.region = Rect2i(0, 0, width, height)
	enemy_pf.cell_size = cellsize
	enemy_pf.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	enemy_pf.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	enemy_pf.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	enemy_pf.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	enemy_pf.jumping_enabled = false
	enemy_pf.update()

func set_cell(cell: GridCell):
	friendly_pf.set_point_weight_scale(cell.coords, cell.get_movement_cost())

func set_obstacle(coords: Vector2i):
	friendly_pf.set_point_solid(coords)
	enemy_pf.set_point_solid(coords)

func set_friendly(coords: Vector2i):
	enemy_pf.set_point_solid(coords)

func set_enemy(coords: Vector2i):
	friendly_pf.set_point_solid(coords)

func move_friendly(start: Vector2i, end: Vector2i):
	enemy_pf.set_point_solid(start, false)
	enemy_pf.set_point_solid(end)

func move_enemy(start: Vector2i, end: Vector2i):
	friendly_pf.set_point_solid(start, false)
	friendly_pf.set_point_solid(end)

func find_path_friendly(start: Vector2i, end: Vector2i):
	return friendly_pf.get_id_path(start, end)

func find_path_enemy(start: Vector2i, end: Vector2i):
	return enemy_pf.get_id_path(start, end)

func destroy_obstacle(coords: Vector2i):
	friendly_pf.set_point_solid(coords, false)
	enemy_pf.set_point_solid(coords, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
