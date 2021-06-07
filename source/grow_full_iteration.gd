extends Node2D
class_name GrowFullIteration

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var word = ""
var grammar = Grammars.wheat_1l()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle()
var line_generator: D0LineGenerator

var time_rules_start: int = 0
var time_rules_end: int = 0
var time_lines_start: int = 0
var time_lines_end: int = 0

signal update_iteration(value)
signal update_word_length(value)
signal update_lines_drawn(value)

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

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and has_next_iteration():
		next_iteration()
		update_stats()
	update()

func _draw():
	for branch in line_generator.lines:
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	time_rules_start = OS.get_ticks_msec()
	word = grammar.apply_productions(word)
	time_rules_end = OS.get_ticks_msec()
	line_generator.generate_lines(word, current_iteration)
	time_lines_end = OS.get_ticks_msec()
	print("apply rules: %s" % (time_rules_end - time_rules_start))
	print("generate lines: %s" %(time_lines_end - time_rules_end))
	current_iteration += 1

func update_stats():
	emit_signal("update_iteration", "%s/%s" % [current_iteration, iterations])
	emit_signal("update_word_length", word.length())
	emit_signal("update_lines_drawn", line_generator.lines.size())
