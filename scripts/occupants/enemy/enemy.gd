class_name Enemy extends Character


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_walkable() -> bool:
	return false;
	
func get_type() -> Occupant_Type:
	return Occupant_Type.ENEMY;

func is_walkable_by_friendly():
	return false

func is_walkable_by_enemy():
	return true

func init_pathfinding():
	Pathfinder.set_enemy(currentCell.coords)
