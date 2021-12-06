signal selected(x, y)
signal moved(x, y)
extends Sprite

var _x := 0
var _y := 0
onready var _tc: TileController = get_parent()

var _holding = false
var _hold_time = 0.0
var hold_options = {
	0.5: null,
	1.0: "p_left",
	1.5: "p_up",
	2.0: "p_right",
	2.5: "p_down",
	3.0: "p_select",
}
var max_time = 3.0

func _ready():
	pass

func _process(dt: float):
	var moved := false
		
	if Input.is_action_just_pressed("p_all"):
		_holding = true
	elif Input.is_action_just_released("p_all"):
		_holding = false
		var p_time = parse_hold_time()
		if p_time != null:
			Input.action_press(p_time)
			
		# snap time to the last 0.5 second interval
		_hold_time = floor(_hold_time * 2) / 2
		
	if _holding:
		_hold_time += dt
		if _hold_time > max_time:
			_hold_time = 0
		
	if Input.is_action_just_pressed("p_click"):
		var act = mouse_control()
		if act:
			Input.action_press(act)
		
	if Input.is_action_just_pressed("p_right"):
		_x += 1
		moved = true
	elif Input.is_action_just_pressed("p_left"):
		_x -= 1
		moved = true
	elif Input.is_action_just_pressed("p_down"):
		_y += 1
		moved = true
	elif Input.is_action_just_pressed("p_up"):
		_y -= 1
		moved = true
		
	_x = _tc.wrap_x(_x)
	_y = _tc.wrap_y(_y)
	if moved:
		emit_signal("moved", _x, _y)
	
	if Input.is_action_just_pressed("p_select"):
		emit_signal("selected", _x, _y)
	
	start()
	
func parse_hold_time():
	for hold_time in hold_options:
		if _hold_time < hold_time:
			return hold_options[hold_time]
	return null
	
func _in_range(x, x_min, x_max) -> bool:
	return x >= x_min and x <= x_max
	
func mouse_control():
	var mpos = get_global_mouse_position()
	mpos = to_local(mpos)
	if mpos.length() < 30:
		return "p_select"
	
	var angle = mpos.angle()
	var q = PI / 4
	
	if _in_range(angle, -q, q):
		return "p_right"
	elif _in_range(angle, q, 3 * q):
		return "p_down"
	elif _in_range(angle, -q * 3, -q):
		return "p_up"
	else:
		return "p_left"
	
func start():
	var tile = _tc.get_tile_by_pos(_x, _y)
	if tile != null:
		position = tile.rect_position + Vector2(32, 32)


func _on_TileController_answer_wrong():
	$AnimationPlayer.play("hurt (copy)")
