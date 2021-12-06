signal answers_generated(answers)
extends Sprite

onready var label: Label = $PanelContainer2/Label
export (NodePath) var tile_c_path = null
export (Array, Resource) var kanji

var rng: RandomNumberGenerator = null
var _tc: TileController = null

func random_pick_kanji(list: Array) -> KanjiData:
	var i = rng.randi_range(0, list.size() - 1)
	return list[i] as KanjiData

func _ready():
	_tc = get_node(tile_c_path)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	generate_question()

func generate_question():
	
	var correctk = random_pick_kanji(kanji)
	var correct = [ correctk ]
	correct.append_array((generate_wrong_answers(correctk)))
	label.text = correctk.meaning
	emit_signal("answers_generated", correct)

func generate_wrong_answers(correct: KanjiData) -> Array:
	var tcount = _tc.tile_cols * _tc.tile_rows
	var tmp = []
	while tmp.size() + 1 < tcount:
		var rand := random_pick_kanji(kanji)
		if rand.meaning == correct.meaning:
			continue
		
		var found := false
		for tkanji in tmp:
			if tkanji.meaning == rand.meaning:
				found = true 
				break 
		if found:
			continue
		tmp.append(rand)
	return tmp


func _on_TileController_answer_right():
	$AnimationPlayer.play("hurt")
	generate_question()
