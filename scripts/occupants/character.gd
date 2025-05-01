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

func move(newCell: GridCell) -> bool:
	print("Move Called!")
	if not newCell.is_walkable():
		return false
	currentCell.unoccupy()
	newCell.occupy(self)
	currentCell = newCell
	var newLoc = grid.global_from_cell(newCell)
	animate_move(newLoc)
	return true

func animate_move(target: Vector2i) -> void:
	# placeholder, change later
	global_position = target
