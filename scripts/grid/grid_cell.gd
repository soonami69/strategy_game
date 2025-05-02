class_name GridCell extends Node2D

@export_category("Cell Parameters")
@export var cellSize: int = 10;
@export var movementCost: int = 1;
@export var currentOccupant: Occupant;
var coords: Vector2i;

static func create(xCoord: int, yCoord: int) -> GridCell:
	var newCell = GridCell.new()
	newCell.coords = Vector2i(xCoord, yCoord)
	return newCell

func is_walkable() -> bool:
	return currentOccupant == null or currentOccupant.is_walkable();
	
func occupy(newOccupant: Occupant) -> void:
	assert(currentOccupant == null, "Cell already has an occupant!");
	currentOccupant = newOccupant;
	print(str(self) + " has been successfully occupied.")
	
func unoccupy() -> void:
	assert(currentOccupant != null, "Cell has no occupant to release!");
	currentOccupant = null;
	print(str(self) + " has been successfully unoccupied.")
	
func get_movement_cost():
	return movementCost

func get_occupant() -> Occupant:
	return currentOccupant;

# Override
func _to_string() -> String:
	return "Cell: (" + str(coords.x) + ", " + str(coords.y) + ")"

# function to check if two grid cells are equal
func equals(other: GridCell) -> bool:
	return other.coords == self.coords
