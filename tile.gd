class_name Tile
extends TextureRect

onready var _label = $Label

func set_label(text: String):
	_label.text = text
	
func get_label() -> String:
	return _label.text
