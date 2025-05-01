class_name Character extends Occupant
# class that represents a character that can move.

var movement_range: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_walkable():
	return false;

func move(newGrid: GridCell) -> bool:
	if not newGrid.is_walkable():
		return false
	currentGrid.unoccupy()
	newGrid.occupy(self)
	currentGrid = newGrid
	return true
