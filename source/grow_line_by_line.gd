extends Node2D
class_name GrowLineByLine

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var current_line = -1
var word = ""
var grammar = Grammars.wheat_1l()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle() + _25degrees
var turtle: Turtle

func _ready():
	word = grammar.axiom
	initialize_turtle()
	turtle.generate_lines(word, current_iteration)

func initialize_turtle():
	turtle = Turtle.new()
	turtle.start = start
	turtle.start_angle = start_angle
	turtle.turn_degrees = _25degrees
	turtle.segment_length = branch_length

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_iteration():
		next_iteration()
	if Input.is_action_pressed("next_step") and has_next_line():
		next_line()

func _draw():
	if current_line < 0:
		return
	for i in range(current_line):
		var branch = turtle.lines[i]
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_line():
	return current_line < turtle.lines.size()

func next_line():
	current_line += 1
	update()

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	current_line = -1
	word = grammar.apply_productions(word)
	turtle.generate_lines(word, current_iteration)
	current_iteration += 1
