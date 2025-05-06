class_name Character extends Occupant
# class that represents a character that can move.

var movement_range: int = 5
var attack_range: int = 1
var pathfinder: AStarGrid2D
var character_manager: CharacterManager
@export var total_health: int = 20
var current_health = total_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_walkable():
	return true;

func is_walkable_by_friendly():
	return true

func is_walkable_by_enemy():
	return true

func init_pathfinding():
	Pathfinder.set_obstacle(currentCell.coords)

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

func register_manager(gridManager: GridManager) -> void:
	self.grid = gridManager
	global_position = grid.global_to_closest_cell(global_position)
	currentCell = grid.cell_from_global(global_position)
	if (currentCell == null):
		print(str(global_position))
		print(str(grid.global_to_map(global_position)))
	currentCell.occupy(self)

func register_character_manager(charManager: CharacterManager) -> void:
	self.character_manager = charManager

func animate_move(path: Array[Vector2i]) -> void:
	# placeholder, change later
	pass

# function to attack
func attack(target: Character):
	print("Bonk!")
	target.take_damage(1)
	
func take_damage(amount: int):
	current_health -= 10
	if current_health < 0:
		current_health = 0
		die()
		
func die():
	character_manager.remove_character(self)
