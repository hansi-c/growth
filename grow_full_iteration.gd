extends Node2D
class_name GrowFullIteration

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var word = ""
#var grammar = Grammars.wheat_grammar()
var grammar = Grammars.some_random_grammar()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle()
var line_generator: D0LineGenerator

func _ready():
	word = grammar.axiom
	initialize_line_generator()
	line_generator.generate_lines(word, current_iteration)

func initialize_line_generator():
	line_generator = D0LineGenerator.new()
	line_generator.start = start
	line_generator.start_angle = start_angle
	line_generator.turn_degrees = _25degrees
	line_generator.segment_length = branch_length
	line_generator.grammar = grammar

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_iteration():
		next_iteration()
	update()

func _draw():
	for branch in line_generator.lines:
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	word = grammar.apply_rules(word)
	line_generator.generate_lines(word, current_iteration)
	current_iteration += 1
