extends Node2D
class_name GrowLineByLine

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var current_line = -1
var word = ""
var lines = []
var grammar = Grammars.wheat_grammar()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle() + _25degrees
var state = PlantState.new()

func _ready():
	word = grammar.axiom
	generate_lines()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_iteration():
		next_iteration()
	if Input.is_action_pressed("next_step") and has_next_line():
		next_line()
	update()

func _draw():
	if current_line < 0:
		return
#	for branch in lines:
	for i in range(current_line):
		var branch = lines[i]
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_line():
	return current_line < lines.size()

func next_line():
	current_line += 1

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	current_line = -1
	word = grammar.apply_rules(word)
	generate_lines()
	current_iteration += 1

func generate_lines():
	print("iteration: %s" % current_iteration)
	lines.clear()
	state.set_position(start)
	state.set_angle(start_angle)
	state.set_width(current_iteration)
	var degrees = _25degrees

	for s in word:
		if s == "F":
			var direction = Vector2(cos(state.angle), sin(state.angle))
			var branch = generate_branch(state.position, direction, state.width)
			lines.append(branch)
			state.position = branch.end
		elif s == "-":
			state.turn_clockwise(degrees)
			state.change_width(-1.0)
		elif s == "+":
			state.turn_counter_clockwise(degrees)
			state.change_width(-1.0)
		elif s == "[":
			state.push_state()
		elif s == "]":
			state.pop_state()
		elif s != "X":
			push_error("unknown symbol: %s" % s)

func generate_branch(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * branch_length)
	result.width = width
	return result
