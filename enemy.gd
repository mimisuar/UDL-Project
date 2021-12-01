signal answers_generated(answers)
extends Sprite

onready var label: Label = $PanelContainer2/Label
export (NodePath) var tile_c_path = null

var rng: RandomNumberGenerator = null
var _tc: TileController = null

func _ready():
	_tc = get_node(tile_c_path)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	generate_question()

func generate_question():
	emit_signal("answers_generated", [])

func generate_wrong_answers(correct: int, op_ref: FuncRef):
	pass


func _on_TileController_answer_right():
	$AnimationPlayer.play("hurt")
	generate_question()
