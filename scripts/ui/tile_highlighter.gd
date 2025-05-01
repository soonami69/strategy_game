extends Node2D

@export var map: TileMapLayer;
@onready var tile_highlighter: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(map != null, "Map not instantiated in GridManager!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# get mouse position
	var mouse_position = map.local_to_map(map.get_local_mouse_position())
	# check if there is a cell there
	if map.get_cell_source_id(mouse_position) == -1:
		tile_highlighter.visible = false;
		return;
	# get the global coords
	var tile_position = map.to_global(map.map_to_local(mouse_position))
	tile_highlighter.global_position = tile_position
	tile_highlighter.visible = true;
