extends CanvasItem
class_name GrowSmoothTransitions

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var current_symbol = 0
var word = ""
var lines = []
var grammar = Grammars.wheat_grammar()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle() + _25degrees
var state = PlantState.new()
var last_rule # used only for stats

onready var stats_label = get_node("StatsLabel")

signal update_iteration(bla)
signal update_word_length(bla)
signal update_current_symbol(bola)
signal update_lines_drawn(bla)
signal update_last_rule(bla)

func _ready():
	word = grammar.start
	update_stats_label()

func _input(_event):
	if has_next_iteration():
		if is_iteration_finished():
			next_iteration()
		elif Input.is_action_pressed("next_step") and has_next_rule():
			next_rule()
		elif Input.is_action_just_pressed("ui_accept"):
			while has_next_rule():
				next_rule()
#		update_stats_label()
		update_stats()

func _process(_delta):
	update()

func _draw():
	for branch in lines:
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
	last_rule = "%s -> %s" % [rule, production]
	current_symbol += production.length()
	generate_lines()

func generate_lines():
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

# FIXME this looks ugly. unfortunately tabs have no effect on normal labels.
# have to use a rich text label or multiple labels
func update_stats_label():
	var text = "iteration:           %s/%s\nword length:      %s\ncurrent symbol: %s\nlines drawn:       %s" % [
		current_iteration, iterations, word.length(), current_symbol, lines.size()]
	stats_label.set_text(text)

func update_stats():
	emit_signal("update_iteration", current_iteration)
	emit_signal("update_word_length", word.length())
	emit_signal("update_current_symbol", current_symbol)
	emit_signal("update_lines_drawn", lines.size())
	emit_signal("update_last_rule", last_rule)
