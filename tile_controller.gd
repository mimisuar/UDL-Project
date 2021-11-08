class_name TileController
extends Node2D

export(int, 1, 4) var tile_rows := 2
export(int, 1, 4) var tile_cols := 2
export var margin := 32 # space between tiles
export(NodePath) var camera_path

var _tiles := []

var tiles_rect := Rect2()
#onready var _init_pos: Position2D = get_node("InitialPosition")

var _tile_text = preload("res://sprites/tile.png")

func _calc_bounds():
	var size = _tile_text.get_size()
	var tiles_size = Vector2()
	tiles_size.x = (margin + size.x) * (tile_cols - 1) + size.x
	tiles_size.y = (margin + size.y) * (tile_rows - 1) + size.y
	
	var tiles_position = -size / 2
	tiles_rect = Rect2(tiles_position, tiles_size)
	
	var center = tiles_rect.size / 2 + tiles_rect.position
	get_node(camera_path).position = center + Vector2(0, -64)
	

func _ready():
	_calc_bounds()
	var x_pos = 0
	var y_pos = 0
	
	for row in range(tile_rows):
		for col in range(tile_cols):
			var tmp_tile = Sprite.new()
			tmp_tile.texture = _tile_text
			tmp_tile.position = Vector2(x_pos, y_pos)
			_tiles.append(tmp_tile)
			add_child(tmp_tile)
			
			x_pos += _tile_text.get_width() + margin
		y_pos += _tile_text.get_height() + margin
		x_pos = 0
	$Player.start()
	
func get_tile_by_pos(x: int, y: int):
	if x >= 0 and x < tile_cols and y >= 0 and y < tile_rows:
		var i = y * tile_cols + x
		if i >= 0 and i < _tiles.size():
			return _tiles[i]
	return null
	
func wrap_x(x: int):
	if x < 0:
		return tile_cols - 1
	elif x >= tile_cols:
		return 0
	return x

func wrap_y(y: int):
	if y < 0:
		return tile_rows - 1
	elif y >= tile_rows:
		return 0
	return y
