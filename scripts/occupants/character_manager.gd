class_name CharacterManager extends Node2D

@export var grid_manager: GridManager;
@export var friendly_characters: Array[Friendly] = [];
@export var enemy_characters: Array[Character] = [];

var friendly_astar: AStarGrid2D = AStarGrid2D.new()
var enemy_astar:AStarGrid2D = AStarGrid2D.new() 

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(grid_manager != null, "Please add a grid manager to the character manager!")
	var nodes = get_tree().get_root().get_children()
	for node in nodes:
		find_occupants_recursive(node)

func find_occupants_recursive(node: Node):
	if node is Occupant:
		register_occupant(node)
	for child in node.get_children():
		find_occupants_recursive(child)


func register_occupant(character: Occupant):
	if character is Friendly:
		friendly_characters.append(character)
	elif character is Enemy:
		enemy_characters.append(character)
	character.registerManager(grid_manager)
	character.init_pathfinding()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func remove_character(character: Character):
	if character is Friendly:
		remove_friendly(character);
	elif character is Enemy:
		remove_enemy(character);
	else:
		printerr("Target type is not a friendly or enemy?")
	
func remove_friendly(friendly: Friendly) -> void:
	friendly_characters.erase(friendly)
	
func remove_enemy(enemy: Enemy) -> void:
	enemy_characters.erase(enemy);
