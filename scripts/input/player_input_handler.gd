extends Node2D

@export var characterManager: CharacterManager
@export var gridManager: GridManager

var currentFriendly: Friendly;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(characterManager != null, "Please assign a CharacterManager to PlayerInputHandler!")
	assert(gridManager != null, "Please assign a GridManager to PlayerInputHandler!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Select"):
		handle_selection()
	elif event.is_action_pressed("Move"):
		handle_move()

func get_targeted_cell() -> GridCell:
	return gridManager.cell_from_global(get_global_mouse_position())

func handle_selection() -> void:
	print("Selection event fired!")
	var targetedCell = get_targeted_cell()
	print(str(targetedCell))
	var occupant: Occupant = get_targeted_cell().get_occupant()
	
	if occupant == null:
		currentFriendly = null;
		print("No object found!")
		return;
	elif occupant is Friendly:
		currentFriendly = occupant;
		print("Occupant selected!")
		return;
	elif occupant is Character:
		print("Character selected!")
		currentFriendly = null;
		return;
	else:
		print("Default case for selection hit!")
		currentFriendly = null;

func handle_move() -> void:
	if currentFriendly == null:
		return;
	var targetCell: GridCell = get_targeted_cell()
	
	if targetCell == null:
		return
	
	if targetCell.equals(currentFriendly.currentCell):
		return
		
	currentFriendly.move(targetCell)
