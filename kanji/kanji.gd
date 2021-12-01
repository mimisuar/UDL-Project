extends Node2D

var _strokes := []
var _lines_max := -1 # max number of lines to draw
var point_count = 0

export(Resource) var kanji_data
export var do_slow_show = false
export(float, 0.01, 1) var slow_show_time = 0.01

class Stroke:
	var curve: Curve2D
	var offset: Vector2

func _fetch_paths():
	var found = []
	for i in get_child_count():
		var child = get_child(i) as Path2D
		if child != null:
			found.append(child)
	return found
	
func slow_show():
	# display the kanji stroke by stroke #
	_lines_max = 0
	while _lines_max < point_count - 1:
		yield(get_tree().create_timer(slow_show_time), "timeout")
		_lines_max += 1
		update()
	print("slow show done")

func _ready():
	var _curves = _fetch_paths()
	for curve in _curves:
		curve = curve as Path2D
		#var lines = curve.tessellate(7) as PoolVector2Array
		var s = Stroke.new()
		s.curve = curve.curve
		s.offset = curve.global_position
		_strokes.append(s)
		point_count += len(s.curve.get_baked_points())
	if do_slow_show:
		slow_show()
	

func _draw():
	var lines_drawn = 0
	for stroke in _strokes:
		stroke = stroke as Stroke
		var points = stroke.curve.get_baked_points()
		for i in len(points) - 1:
			if _lines_max >= 0 and lines_drawn >= _lines_max:
				return
			
			var p0 = points[i]
			var p1 = points[i + 1]
			
			draw_line(p0, p1, Color.black, 2)
			lines_drawn += 1
	
func _fast_draw():
	# use tesselate to draw everything
	pass
	
func _slow_draw():
	pass
