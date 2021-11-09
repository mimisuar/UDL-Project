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
	
		
	if Input.is_action_just_pressed("p_all"):
		_holding = true
		_hold_time = 0.0
	elif Input.is_action_just_released("p_all"):
		_holding = false
		var p_time = parse_hold_time()
		if p_time != null:
			Input.action_press(p_time)
	if _holding:
		_hold_time += dt
		if _hold_time > max_time:
			_hold_time = 0
		
	if Input.is_action_just_pressed("p_click"):
		var act = mouse_control()
		if act:
			print(act)
		
	if Input.is_action_just_pressed("p_right"):
		_x += 1
	elif Input.is_action_just_pressed("p_left"):
		_x -= 1
	elif Input.is_action_just_pressed("p_down"):
		_y += 1
	elif Input.is_action_just_pressed("p_up"):
		_y -= 1
		
	
		
	_x = _tc.wrap_x(_x)
	_y = _tc.wrap_y(_y)
	
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
		position = tile.position
