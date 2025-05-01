extends Node2D

enum Turn {
	PLAYER_TURN,
	ENEMY_TURN
}

signal turn_started(current_turn: Turn)

var current_turn: Turn = Turn.PLAYER_TURN;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_turn() -> Turn:
	return current_turn
	
func next_turn() -> void:
	if current_turn == Turn.PLAYER_TURN:
		current_turn = Turn.ENEMY_TURN
	else:
		current_turn = Turn.PLAYER_TURN
	emit_signal("turn_started", current_turn)
