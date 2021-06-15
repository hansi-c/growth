class_name Turtle

var lines = []
var leaves = []
var fruits = []
var state = TurtleState.new()
var abilities = {}
var config: TurtleConfig

func _init(_config: TurtleConfig):
	config = _config
	add_ability("F", "draw_line")
	add_ability("G", "draw_line")
	add_ability("-", "turn_cw")
	add_ability("+", "turn_ccw")
	add_ability("[", "open_branch")
	add_ability("]", "close_branch")
	add_ability("A", "shape_1")
	add_ability("B", "shape_2")

func generate_lines(word, initial_width: float):
	lines.clear()
	leaves.clear()
	fruits.clear()
	state.set_width(initial_width)
	state.set_position(config.start_pos)
	state.set_angle(config.start_angle)

	for i in range(word.length()):
		var s = word[i]
		if abilities.has(s):
			var ability = abilities[s]
			ability.call_func()

func add_ability(symbol: String, ability: String):
	var call = FuncRef.new()
	call.set_instance(self)
	call.set_function(ability)
	abilities[symbol] = call

func draw_line():
	var direction = Vector2(cos(state.angle), sin(state.angle))
	var line_segment = _line_segment(state.position, direction, state.width)
	lines.append(line_segment)
	state.position = line_segment.end
	
func _line_segment(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * config.line_length)
	result.width = width
	return result
	
func turn_ccw():
	state.turn_counter_clockwise(config.turn_angle)

func turn_cw():
	state.turn_clockwise(config.turn_angle)

func open_branch():
	state.push_state()
	state.width *= config.width_falloff

func close_branch():
	state.pop_state()

func shape_1():
	leaves.append(state.position + Vector2(0,2.0))
	
func shape_2():
	fruits.append(state.position + Vector2(0,2.0))

func reset():
	state.reset()
	lines.clear()
	leaves.clear()
	fruits.clear()
