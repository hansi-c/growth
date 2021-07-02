extends CanvasItem
class_name GrowContextFull

export var iterations = 6
export var start = Vector2(500, 400)
export var random_seed = 1
export var dynamic_line_width = true
var current_iteration = 0
var current_symbol = 0
var word = ""
var grammar: ILGrammar
var turtle: Turtle = Turtle.new()
var production_picker: ProductionPicker
# cosmetics
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
#	_initialize_turtle()
	_initialize_rng_state()
	_initialize_production_picker()
	_initialize_cosmetics()

func _initialize_cosmetics():
	var cosmeticContainer = "../../../GUI/Indented/CosmeticsContainer/"
	var color_fruit_node = get_node_or_null(cosmeticContainer+"FruitColorPicker")
	var color_leaf_node = get_node_or_null(cosmeticContainer+"LeavesColorPicker")
	var color_stem_node = get_node_or_null(cosmeticContainer+"StemColorPicker")
	var size_fruit_node = get_node_or_null(cosmeticContainer+"FruitRadiusSlider")
	var size_leaf_node = get_node_or_null(cosmeticContainer+"LeafRadiusSlider")
	var size_stem_node = get_node_or_null(cosmeticContainer+"StemThicknessSlider")

	if color_fruit_node:
		color_fruit = color_fruit_node.color
	if color_leaf_node:
		color_leaves = color_leaf_node.color
	if color_stem_node:
		color_stem = color_stem_node.color
	if size_fruit_node:
		fruit_radius = size_fruit_node.value
	if size_leaf_node:
		leaves_radius = size_leaf_node.value
	if size_stem_node:
		stem_thickness = size_stem_node.value

func reset():
	current_iteration = 0
	current_symbol = 0
	word = grammar.axiom
	Globals.rng_state.reset()
	turtle.reset()
	generate_geometry()
	_update_stats()
	_emit_iteration_update()
	emit_signal("iterations_reset")

func _get_starting_position():
	var start_pos_node = get_node_or_null("GrowthStartPosition")
	if start_pos_node:
		start = start_pos_node.position

#func _initialize_turtle():
#	turtle.start_position = start

func _initialize_rng_state():
	Globals.rng_state.rng = RandomNumberGenerator.new()
	Globals.rng_state.initialize(random_seed)

func _initialize_production_picker():
	production_picker = StochasticProductionPicker.new(Globals.rng_state.rng)

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
	var num_lines_before = turtle.lines.size()
	var num_leaves_before = turtle.leaves.size()
	var num_fruits_before = turtle.fruits.size()
	var initial_width
	if dynamic_line_width:
		initial_width = (current_iteration+1)# * 0.66
	else:
		initial_width = 1.0
	turtle.generate_geometry(word, initial_width)
	var num_lines_after = turtle.lines.size()
	var num_leaves_after = turtle.leaves.size()
	var num_fruits_after = turtle.fruits.size()
	
	if num_lines_before != num_lines_after:
		emit_signal("update_line_segments", num_lines_after)
	if num_leaves_before != num_leaves_after:
		emit_signal("update_leaves", num_leaves_after)
	if num_fruits_before != num_fruits_after:
		emit_signal("update_fruits", num_fruits_after)
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

func _on_preset_selected(preset: Preset):
#	print("preset selected")
	grammar = preset.grammar
	grammar.production_picker = production_picker
#	turtle.set_config(preset.config)
	preset.turtle_settings.start_position = start
	turtle.set_settings(preset.turtle_settings)
	turtle.set_abilities(preset.turtle_abilities)
	
	reset()

func _on_EditButton_button_up():
	Globals.grammar = grammar
	var c = turtle.get_abilities()
	Globals.turtle_abilities = turtle.get_abilities()
	Globals.turtle_settings = turtle.get_settings()
#	Globals.turtle_config = turtle.get_config()
	var error = get_tree().change_scene("res://source/editor/grammar_editor.tscn")
	if error:
		print("could not change scene: %s" % error)
