extends Node2D
class_name GrowWheat

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var word = ""
var lines = []
#var grammar = Grammars.wheat_grammar()
var grammar = Grammars.tomato_grammar()
var _25degrees = deg2rad(25.0)
#var start_angle = Vector2.UP.angle() + _25degrees
var start_angle = Vector2.UP.angle()
var tomatoes = []

func _ready():
	word = grammar.start
	generate_lines()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_iteration():
		next_iteration()
	update()

func _draw():
	for branch in lines:
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	word = grammar.apply_rules(word)
	generate_lines()
	current_iteration += 1

func generate_lines():
	lines.clear()

	var positions = []
	var angles = []
	var widths = []
	var position = start
	var angle = start_angle
	var width = current_iteration

	for s in word:
		var degrees = _25degrees
		if s == "F":
			var direction = Vector2(cos(angle), sin(angle))
			var branch = generate_branch(position, direction, width)
			lines.append(branch)
			position = branch.end
		elif s == "-":
			angle += degrees
			width -= 1
		elif s == "+":
			angle -= degrees
			width -= 1
		elif s == "[":
			positions.push_back(position)
			angles.push_back(angle)
			widths.push_back(width)
		elif s == "]":
			position = positions.pop_back()
			angle = angles.pop_back()
			width = widths.pop_back()
		elif s != "X":
			push_error("unknown symbol: %s" % s)

func generate_branch(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * branch_length)
	result.width = width
	return result
