class_name BasicWall extends Occupant

func get_type() -> Occupant_Type:
	return Occupant_Type.OBSTACLE
	
func is_walkable() -> bool:
	return false
