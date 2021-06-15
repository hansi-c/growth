extends CanvasItem
class_name GrowContextFull

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var _25degrees = deg2rad(25.0)
export var turn_angle = deg2rad(25.0)
export var start_angle = -1.0 #Vector2.UP.angle() + _25degrees
export var random_seed = 1
var current_iteration = 0
var current_symbol = 0
var word = ""
var grammar = Grammars.wheat_1l()
#var grammar = Grammars.sierpinski_triangle()
var turtle: Turtle
var rng_state: RngState
var color_fruit = Color.red
var color_leaves = Color.green
var color_stem = Color.brown
var leaves_radius = 3.0
var fruit_radius = 5.0
var stem_thickness = 1.0

# button signals
signal max_iteration_reached()
signal iterations_reset()
# stats signals
signal update_current_iteration(current, maximum)
signal update_current_symbol(current, maximum)
signal update_leaves(amount)
signal update_fruits(amount)
signal update_line_segments(amount)

func _ready():
	_get_starting_position()
	_initialize_turtle()
	_initialize_rng_state()
	_initialize_production_picker()
	reset()

func reset():
	current_iteration = 0
	current_symbol = 0
	word = grammar.axiom
	rng_state.reset()
	turtle.reset()
	generate_geometry()
	_update_stats()
	_emit_iteration_update()
	emit_signal("iterations_reset")

func _get_starting_position():
	var start_pos = get_node_or_null("GrowthStartPosition")
	if start_pos:
		start = start_pos.position

func _initialize_turtle():
	var config = TurtleConfig.new()
	config.start_angle = start_angle
	config.start_pos = start
	config.turn_angle = turn_angle
	config.line_length = branch_length
	config.width_falloff = 0.66
	turtle = Turtle.new(config)

func _initialize_rng_state():
	rng_state = RngState.new()
	rng_state.rng = RandomNumberGenerator.new()
	rng_state.initialize(random_seed)

func _initialize_production_picker():
	grammar.production_picker = StochasticProductionPicker.new(rng_state.rng)

func _emit_iteration_update():
	emit_signal("update_current_iteration", current_iteration, iterations)
	emit_signal("update_current_symbol", current_symbol, word.length())

func _update_stats():
	emit_signal("update_fruits", turtle.fruits.size())
	emit_signal("update_leaves", turtle.leaves.size())
	emit_signal("update_line_segments", turtle.lines.size())

func _draw():
	for line in turtle.lines:
		_draw_stem(line)
	for position in turtle.leaves:
		_draw_leave(position)
	for position in turtle.fruits:
		_draw_fruit(position)
		
func _draw_stem(line_segment):
	draw_line(line_segment.start, line_segment.end, color_stem,
		line_segment.width * stem_thickness)

func _draw_leave(position):
	draw_circle(position, leaves_radius, color_leaves)

func _draw_fruit(position):
	draw_circle(position, fruit_radius, color_fruit)

func _on_Timer_timeout():
	if has_next_iteration():
		if is_iteration_finished():
			next_iteration()
		if has_next_iteration() and has_next_rule():
			next_rule()
			generate_geometry()

func _on_FinishIteration():
	if has_next_iteration():
		while not is_iteration_finished() and has_next_rule():
			next_rule()
		generate_geometry()
#		var applied_production = ILGrammar.AppliedProduction.new()
#		while not is_iteration_finished() and grammar.apply_next_production(
#				word, current_symbol, applied_production):
#			word = applied_production.word
#			current_symbol = applied_production.next_index
		if has_next_iteration():
			next_iteration()
#	print(word)

func has_next_iteration():
	return current_iteration < iterations

func is_iteration_finished():
	return current_symbol >= word.length()

func next_iteration():
	current_symbol = 0
	current_iteration += 1
	_emit_iteration_update()
	if not has_next_iteration():
		emit_signal("max_iteration_reached")

func has_next_rule():
	current_symbol = grammar.find_next_rule(word, current_symbol)
	return current_symbol < word.length()

func next_rule():
	var last_production = [null]
	word = grammar.apply_production(word, current_symbol, last_production)
	current_symbol += last_production[0].successor.length()
	emit_signal("update_current_symbol", current_symbol, word.length())

func generate_geometry():
	var num_lines = turtle.lines.size()
	var num_leaves = turtle.leaves.size()
	var num_fruits = turtle.fruits.size()
	
	var initial_width = (current_iteration+1) * 0.66
	turtle.generate_lines(word, initial_width)
	
	if turtle.lines.size() != num_lines:
		emit_signal("update_line_segments", turtle.lines.size())
	if turtle.leaves.size() != num_leaves:
		emit_signal("update_leaves", turtle.leaves.size())
	if turtle.fruits.size() != num_fruits:
		emit_signal("update_fruits", turtle.fruits.size())
	
	update()

func _on_FruitColorPickerButton_color_changed(color):
	color_fruit = color
	update()

func _on_LeavesColorPickerButton_color_changed(color):
	color_leaves = color
	update()

func _on_StemColorPickerButton_color_changed(color):
	color_stem = color
	update()

func _on_LeafRadiusSlider_value_changed(value):
	leaves_radius = value
	update()

func _on_FruitRadiusSlider_value_changed(value):
	fruit_radius = value
	update()

func _on_StemThicknessSlider_value_changed(value):
	stem_thickness = value
	update()

func _on_ResetButton_button_up():
	reset()
