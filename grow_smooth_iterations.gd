extends CanvasItem
class_name GrowSmoothTransitions

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle() + _25degrees
var current_iteration = 0
var current_symbol = 0
var word = ""
var grammar = Grammars.wheat_grammar()
#var grammar = Grammars.tomato_grammar()
var last_rule # used only for stats
var line_generator: D0LineGenerator

signal update_iteration(value)
signal update_word_length(value)
signal update_current_symbol(value)
signal update_lines_drawn(value)
signal update_last_rule(value)
signal update_angle(value)

func _ready():
	word = grammar.axiom
	initialize_line_generator()
	update_stats()

func initialize_line_generator():
	line_generator = D0LineGenerator.new()
	line_generator.start = start
	line_generator.start_angle = start_angle
	line_generator.turn_degrees = _25degrees
	line_generator.segment_length = branch_length
	line_generator.grammar = grammar

func _input(_event):
	if has_next_iteration():
		if is_iteration_finished():
			next_iteration()
		elif Input.is_action_pressed("next_step") and has_next_rule():
			next_rule()
		elif Input.is_action_just_pressed("ui_accept"):
			while has_next_rule():
				next_rule()
		update_stats()

func _process(_delta):
	update()

func _draw():
	for branch in line_generator.lines:
		draw_line(branch.start, branch.end, Color.green, branch.width)

func has_next_iteration():
	return current_iteration < iterations

func is_iteration_finished():
	return current_symbol >= word.length()

func next_iteration():
	current_symbol = 0
	current_iteration += 1

func has_next_rule():
	while current_symbol < word.length():
		var symbol = word[current_symbol]
		if grammar.rules.has(symbol):
			return true
		current_symbol += 1
	return false

func next_rule():
	var rule = word[current_symbol]
	word = grammar.apply_rule(word, current_symbol)
	var production = grammar.rules[rule]
	last_rule = "%s -> %s" % [rule, production] # just for stats
	current_symbol += production.length()
	line_generator.generate_lines(word, current_iteration)

func update_stats():
	emit_signal("update_iteration", "%s/%s" % [current_iteration, iterations])
	emit_signal("update_word_length", word.length())
	emit_signal("update_current_symbol", current_symbol)
	emit_signal("update_lines_drawn", line_generator.lines.size())
	emit_signal("update_last_rule", last_rule)
	if line_generator.lines.size() > 0:
		var last_branch = line_generator.lines[line_generator.lines.size()-1]
		var direction = last_branch.start - last_branch.end
		var angle = direction.angle()
		emit_signal("update_angle", rad2deg(angle))
