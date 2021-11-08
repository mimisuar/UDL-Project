extends Control

onready var _options: OptionButton = $PanelContainer/VBoxContainer/OptionButton
onready var _action_rect: TextureRect = $PanelContainer/VBoxContainer/CenterContainer/TextureRect
var _player = null

const WASD := "WASD + Space"
const SPACE := "Space"
const MOUSE := "Mouse"

export(NodePath) var player_path
export(AtlasTexture) var left
export(AtlasTexture) var right
export(AtlasTexture) var up
export(AtlasTexture) var down
export(AtlasTexture) var select
export(AtlasTexture) var none

onready var _action_to_text = {
	null: none,
	"p_left": left,
	"p_right": right,
	"p_up": up,
	"p_down": down,
	"p_select": select
}

func _gen_dict() -> Dictionary:
	return {
	"p_left": null,
	"p_right": null,
	"p_up": null,
	"p_down": null,
	"p_select": null,
	"p_all": null
	}

var input_events_wasd := _gen_dict()
var input_events_space := _gen_dict()
var input_events_mouse := _gen_dict()

func _ready():
	init_map()
	_options.add_item(WASD, 0)
	_options.add_item(SPACE, 1)
	_options.add_item(MOUSE, 2)
	_player = get_node(player_path)
	
	var tmp = InputEventKey.new()
	tmp.scancode = KEY_A
	input_events_wasd["p_left"] = tmp
	
	tmp = InputEventKey.new()
	tmp.scancode = KEY_D
	input_events_wasd["p_right"] = tmp
	
	tmp = InputEventKey.new()
	tmp.scancode = KEY_W
	input_events_wasd["p_up"] = tmp
	
	tmp = InputEventKey.new()
	tmp.scancode = KEY_S
	input_events_wasd["p_down"] = tmp
	
	tmp = InputEventKey.new()
	tmp.scancode = KEY_SPACE
	input_events_wasd["p_select"] = tmp
	input_events_space["p_all"] = tmp
	
	_options.select(1)
	update_current_item()
	
func _process(dt: float):
	var idx = _options.get_selected_id()
	if idx == 1:
		# space mode 
		var p_time = _player.parse_hold_time()
		_action_rect.texture = _action_to_text[p_time]
	
func update_current_item():
	var index = _options.get_selected_id()
	if index == 0:
		switch_controls(input_events_wasd)
	elif index == 1:
		switch_controls(input_events_space)
	elif index == 2:
		switch_controls(input_events_mouse)
		
	yield(get_tree().create_timer(0.01), "timeout")
	var own = get_focus_owner()
	if own != null:
		own.release_focus()

func _on_OptionButton_item_selected(index):
	update_current_item()

func init_map():
	for action in input_events_wasd:
		InputMap.add_action(action)

func clear_map():
	for action in input_events_wasd:
		InputMap.action_erase_events(action)
	
func switch_controls(mapping):
	clear_map()
	for action in mapping:
		var input_event = mapping[action]
		if input_event != null:
			InputMap.action_add_event(action, input_event)
