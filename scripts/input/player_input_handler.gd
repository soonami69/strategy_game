extends Node2D

@export var characterManager: CharacterManager
@export var gridManager: GridManager

@onready var arrow_scene: PackedScene = preload("res://scenes/ui/path_arrow.tscn")

var current_friendly: Friendly;
var current_friendly_movement_range: int
var current_friendly_attack_range: int
var current_cell: GridCell
var path: Array[Vector2i]
var pooled_arrow_sprites: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(characterManager != null, "Please assign a CharacterManager to PlayerInputHandler!")
	assert(gridManager != null, "Please assign a GridManager to PlayerInputHandler!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		handle_mouse_movement()
		update_drawn_path()
		print(str(path))
	elif event.is_action_pressed("Select"):
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
		deselect_friendly()
		print("No object found!")
		return;
	elif occupant is Friendly:
		select_friendly(occupant)
		print("Occupant selected!")
		return;
	elif occupant is Character:
		print("Character selected!")
		deselect_friendly()
		return;
	else:
		print("Default case for selection hit!")
		deselect_friendly()

func select_friendly(friendly: Friendly):
	current_friendly = friendly;
	current_friendly_movement_range = friendly.movement_range;
	current_friendly_attack_range = friendly.attack_range;
	path.clear()
	while (pooled_arrow_sprites.size() < current_friendly_movement_range + 1):
		var arrow_instance: Node2D = arrow_scene.instantiate()
		pooled_arrow_sprites.append(arrow_instance)
		add_child(arrow_instance)
	clear_drawn_path()

func deselect_friendly():
	current_friendly = null;
	current_friendly_movement_range = 0;
	current_friendly_attack_range = 0;
	path.clear()

func handle_mouse_movement():
	if current_friendly == null:
		return
	var targetCell = get_targeted_cell()
	if targetCell == null:
		print("no cell targeted!")
		return
	if targetCell.equals(current_cell):
		print("mouse did not hover over a new cell!")
		return;
	var occupant = targetCell.get_occupant()
	if occupant:
		print("cell has occupant!")
		if not occupant.is_walkable_by_friendly():
			print("cell is not walkable by friendly!")
			return
	if targetCell.coords == current_friendly.currentCell.coords:
		path.clear()
		path.append(targetCell.coords)
	if not targetCell.is_neighbor(current_cell):
		path = Pathfinder.find_path_friendly(current_friendly.currentCell.coords, targetCell.coords)
		if path.size() > current_friendly_movement_range:
			print("path longer than movement range of {}. Cutting!", str(current_friendly_movement_range))
			path.clear()
		current_cell = targetCell
		return
	current_cell = targetCell
	# if path does not contain starting cell or is empty, it is an invalid path and we will attempt to recalculate with AStar
	if path.size() == 0 or path[0] != current_friendly.currentCell.coords:
		path = Pathfinder.find_path_friendly(current_friendly.currentCell.coords, targetCell.coords)
		if path.size() > current_friendly_movement_range + 1:
			path.clear()
		return
	var index: int = path.find(targetCell.coords)
	# here, put a check to see if it is part of the path. If it is, we will remove the arrows until we reach it
	if index != -1:
		path = path.slice(0, index + 1)
		print("path cut!")
		return
	path.append(targetCell.coords)
	if path.size() > current_friendly_movement_range + 1:
		path = Pathfinder.find_path_friendly(current_friendly.currentCell.coords, targetCell.coords)
		if path.size() > current_friendly_movement_range + 1:
			print("path longer than movement range of {}. Cutting!", str(current_friendly_movement_range))
			path.clear()

func clear_drawn_path():
	for arrow in pooled_arrow_sprites:
		arrow.visible = false

func update_drawn_path():
	var diff
	if path.size() == 1 or path.size() == 2:
		clear_drawn_path()
		return
	print("updating drawn path: size of path: " + str(path.size()))
	for i in range(1, current_friendly_movement_range):
		print("checking path at i: " + str(i))
		var arrow = pooled_arrow_sprites[i - 1]
		if i >= path.size():
			arrow.visible = false
			continue
		if i == (path.size() - 1):
			arrow.visible = true
			arrow.global_position = gridManager.global_from_index(path[i])
			arrow.rotation = atan2(diff.y, diff.x)
			continue
		var from = gridManager.global_from_index(path[i])
		var to = gridManager.global_from_index(path[i + 1])
		diff = to - from
		
		arrow.visible = true
		arrow.global_position = from
		print("arrow position: " + str(arrow.global_position))
		arrow.rotation = atan2(diff.y, diff.x)
	check_visible_arrows()

func check_visible_arrows():
	var counter = 0;
	for arrow in pooled_arrow_sprites:
		if arrow.visible:
			counter = counter + 1
	print("number of visible arrows is: " + str(counter))

func handle_move() -> void:
	if current_friendly == null:
		return;
	var targetCell: GridCell = get_targeted_cell()
	
	if targetCell == null:
		return
	
	if targetCell.equals(current_friendly.currentCell):
		return
		
	var res = current_friendly.move_along_path(path.duplicate())
	if res:
		print("successful move!")
		path.clear()
		clear_drawn_path()
