signal answers_generated(answers)
extends Sprite

onready var label: Label = $PanelContainer2/Label
export (NodePath) var tile_c_path = null

func add(op1, op2):
	return op1 + op2
func sub(op1, op2):
	return op1 - op2
func mul(op1, op2):
	return op1 * op2
func div(op1, op2):
	return op1 / op2

var ops = {
	"+": funcref(self, "add"),
	"-": funcref(self, "sub"),
	"x": funcref(self, "mul")
}

var op1 := 0
var op2 := 0
var op_key := "+"
var rng: RandomNumberGenerator = null
var _tc: TileController = null

func _ready():
	_tc = get_node(tile_c_path)
	rng = RandomNumberGenerator.new()
	rng.randomize()
	generate_question()

func generate_question():
	
	op1 = rng.randi_range(0, 12)
	op2 = rng.randi_range(0, 12)
	
	var op_keys = ops.keys()
	var op_keys_idx = rng.randi_range(0, op_keys.size() - 1)
	op_key = op_keys[op_keys_idx]
	var txt = str(op1) + " " + op_key + " " + str(op2)
	label.text = txt
	
	var op: FuncRef = ops[op_key]
	var res = op.call_func(op1, op2)
	print(txt, " = ", res)
	var wrong = generate_wrong_answers(res, op)
	var answers = [res]
	answers.append_array(wrong)
	emit_signal("answers_generated", answers)

func generate_wrong_answers(correct: int, op_ref: FuncRef):
	var wrong = []
	var size = _tc.tile_cols * _tc.tile_rows
	while wrong.size() < size - 1:
		var _op1 = rng.randi_range(0, 12)
		var _op2 = rng.randi_range(0, 12)
		
		var wrong_answer = op_ref.call_func(_op1, _op2)
		if wrong_answer == correct or wrong_answer in wrong:
			continue
		wrong.append(wrong_answer)
	return wrong


func _on_TileController_answer_right():
	$AnimationPlayer.play("hurt")
	generate_question()
