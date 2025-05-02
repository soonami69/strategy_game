class_name Friendly extends Character


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_walkable() -> bool:
	return false

func get_type() -> Occupant_Type:
	return Occupant_Type.FRIENDLY

func is_walkable_by_friendly():
	return true

func is_walkable_by_enemy():
	return false

func init_pathfinding():
	Pathfinder.set_friendly(currentCell.coords)


# to be changed when tile highlighter for movement has been implemented
func move(newCell: GridCell) -> bool:
	print("Move Called!")
	var path: Array[Vector2i] = Pathfinder.find_path_friendly(currentCell.coords, newCell.coords)
	if path.size() == 0 or path.size() - 1    > movement_range:
		print("Cell outside movement range!")
		return false
	if newCell.get_occupant() != null:
		return false

	currentCell.unoccupy()
	newCell.occupy(self)
	self.currentCell = newCell
	animate_move(path) 
	return true

func animate_move(path: Array[Vector2i]) -> void:
	for i in range(1, path.size()): # skip the first cell
		var cell = path[i];
		await get_tree().create_timer(0.1).timeout
		global_position = grid.global_from_map(cell)
	
