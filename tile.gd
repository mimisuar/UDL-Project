class_name Tile
extends TextureRect

var _ckanji: Node2D = null
var _kanji: KanjiData = null

func attach_kanji(kj: KanjiData):
	if _ckanji != null:
		remove_child(_ckanji)
	
	_kanji = kj
	_ckanji = kj.kanji_sprite.instance()
	add_child(_ckanji)

func get_kanji() -> KanjiData:
	return _kanji
