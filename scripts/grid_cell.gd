class_name GridCell extends Node2D

@export_category("Cell Parameters")
@export var cellSize: int = 10;
@export var movementCost: int = 1;
@export var currentOccupant: Occupant;
var x: int;
var y: int;

static func create(x: int, y: int) -> GridCell:
	var newCell = GridCell.new()
	newCell.x = x
	newCell.y = y
	return newCell

func is_walkable() -> bool:
	return currentOccupant == null or currentOccupant.is_walkable();
	
func occupy(newOccupant: Occupant) -> void:
	assert(currentOccupant == null, "Cell already has an occupant!");
	currentOccupant = newOccupant;
	print(str(self))
	
func unoccupy() -> void:
	assert(currentOccupant != null, "Cell has no occupant to release!");
	currentOccupant = null;
	
func get_occupant() -> Occupant:
	return currentOccupant;

# Override
func _to_string() -> String:
	return "Cell: (" + str(x) + ", " + str(y) + ")"
