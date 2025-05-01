class_name GridManager extends Node2D

@export var map: TileMapLayer;

var width: int;
var height: int;
var offset: Vector2i;
var cells: Array[Array] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(map != null, "Map not instantiated in GridManager!")
	offset = map.get_used_rect().position
	width = map.get_used_rect().size.x
	height = map.get_used_rect().size.y
	populate() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# populate the cells based on tileMap data
func populate() -> void:
	for x in range(width):
		cells.append([]);
		for y in range(height):
			var tile_id = map.get_cell_source_id(Vector2i(x, y));
			cells[x].append(convert_id_to_cell(x, y, tile_id))
	print("Population successful!");
	print("Size of x: " + str(cells.size()) + " size of y: " + str(cells[0].size()))

func convert_id_to_cell(x:int, y:int, id: int) -> GridCell:
	match id:
		_:
			return GridCell.create(x, y);

func get_occupant_from_cell(x: int, y: int) -> Occupant:
	return cells[x][y].get_occupant();
	
func is_walkable(x: int, y: int) -> bool:
	return cells[x][y].is_walkable();

func global_to_map(coords: Vector2i) -> Vector2i:
	return map.local_to_map(map.to_local(coords))

func global_to_closest_cell(coords: Vector2i) -> Vector2i:
	return map.to_global(map.map_to_local(global_to_map(coords)));

func cell_from_global(coords: Vector2i) -> GridCell:
	var loc: Vector2i = map_to_index(global_to_map(coords))
	return cell_from_index(loc.x, loc.y)

func map_to_index(coords: Vector2i) -> Vector2i:
	return coords - offset

func index_to_map(coords: Vector2i) -> Vector2i:
	return coords + offset

func global_from_cell(cell: GridCell) -> Vector2i:
	return map.to_global(map.map_to_local(index_to_map(Vector2i(cell.x, cell.y))))

func cell_from_index(x: int, y: int) -> GridCell:
	if x < 0 || y < 0 || x >= width || y >= height:
		return null
	return cells[x][y]
