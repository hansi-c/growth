extends Node2D
class_name GrowBinary

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
export var leaf_length = 20.0
var current_step = 0
var word = ""
var lines = []
var grammar = Grammars.binary_tree_grammar()
var start_angle = Vector2.UP.angle()
var _45degrees = deg2rad(45.0)

func _ready():
	word = grammar.start
	generate_lines()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_step():
		next_step()
	update()

func _draw():
	for line in lines:
		draw_line(line[0], line[1], Color.green)

func has_next_step():
	return current_step < iterations

func next_step():
	word = grammar.apply_rules(word)
	generate_lines()
	current_step += 1

func generate_lines():
	lines.clear()

	var positions = []
	var angles = []
	var position = start
	var angle = start_angle

	for s in word:
		if grammar.rules.has(s):
			var direction = Vector2(cos(angle), sin(angle))
			var line = generate_line(s, position, direction)
			lines.append(line)
			if s == "1":
				position = line[1]
		elif s == "[":
			positions.push_front(position)
			angles.push_front(angle)
			angle -= _45degrees
		elif s == "]":
			position = positions.pop_front()
			angle = angles.pop_front() + _45degrees
		else:
			push_error("unknown symbol: %s" % s)

func generate_line(symbol, start, direction):
	var length
	if symbol == "0":
		length = leaf_length
	elif symbol == "1":
		length = branch_length
	return [start, start + (direction * length)]
