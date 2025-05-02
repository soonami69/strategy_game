class_name Occupant extends Node2D

@export var currentCell: GridCell;
var grid: GridManager;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func registerManager(gridManager: GridManager) -> void:
	self.grid = gridManager
	global_position = grid.global_to_closest_cell(global_position)
	currentCell = grid.cell_from_global(global_position)
	if (currentCell == null):
		print(str(global_position))
		print(str(grid.global_to_map(global_position)))
	currentCell.occupy(self)

enum Occupant_Type {
	ENEMY,
	FRIENDLY,
	TRAP,
	OBSTACLE,
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func is_walkable() -> bool:
	return false;

func is_walkable_by_friendly():
	return false

func is_walkable_by_enemy():
	return false

func init_pathfinding():
	Pathfinder.set_obstacle(currentCell.coords)

# Returns the type of Occupant the object is. Useful for quick checks I suppose.
func get_type() -> Occupant_Type:
	printerr("Occupant Type has not been overriden!")
	return Occupant_Type.OBSTACLE;
