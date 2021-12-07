class_name Tile
extends TextureRect

var _kanji: KanjiData = null
onready var _subrect := get_node("TextureRect")

func attach_kanji(kj: KanjiData):
	_kanji = kj
	_subrect.texture = _kanji.texture_rect

func get_kanji() -> KanjiData:
	return _kanji
