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
var turtle: Turtle

var time_rules_start: int = 0
var time_rules_end: int = 0
var time_lines_start: int = 0
var time_lines_end: int = 0

signal update_iteration(value)
signal update_word_length(value)
signal update_lines_drawn(value)

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
		update_stats()
		update()

func _draw():
	for branch in turtle.lines:
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_iteration():
	return current_iteration < iterations

func next_iteration():
	time_rules_start = OS.get_ticks_msec()
	word = grammar.apply_productions(word)
	time_rules_end = OS.get_ticks_msec()
	turtle.generate_lines(word, current_iteration)
	time_lines_end = OS.get_ticks_msec()
	print("apply rules: %s" % (time_rules_end - time_rules_start))
	print("generate lines: %s" %(time_lines_end - time_rules_end))
	current_iteration += 1

func update_stats():
	emit_signal("update_iteration", "%s/%s" % [current_iteration, iterations])
	emit_signal("update_word_length", word.length())
	emit_signal("update_lines_drawn", turtle.lines.size())
