# growth - Lindenmayer Systems implemented in Godot
# Copyright (C) 2021  Christoph Czurda <rdssdf.fd@gmx.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
var word_builder: WordBuilder = WordBuilder.new()
var production_picker: ProductionPicker
var turtle: Turtle = Turtle.new()
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
signal focus_camera(point)
# stats signals
signal update_current_iteration(current, maximum)
signal update_current_symbol(current, maximum)
signal update_leaves(amount)
signal update_fruits(amount)
signal update_line_segments(amount)

func _ready():
	_get_starting_position()
	_initialize_production_picker()
	_initialize_cosmetics()

func _get_starting_position():
	var start_pos_node = get_node_or_null("GrowthStartPosition")
	if start_pos_node:
		start = start_pos_node.position

func _initialize_production_picker():
	_ensure_global_rng_state()
	production_picker = StochasticProductionPicker.new(Globals.rng_state.rng)

func _ensure_global_rng_state():
	if Globals.rng_state == null:
		Globals.rng_state = RngState.new()
		Globals.rng_state.rng = RandomNumberGenerator.new()
		Globals.rng_state.initialize(random_seed)

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
	if Globals.rng_state != null:
		Globals.rng_state.reset()
	turtle.reset()
	generate_geometry()
	_update_stats()
	_emit_iteration_update()
	emit_signal("iterations_reset")

func _emit_iteration_update():
	emit_signal("update_current_iteration", current_iteration, iterations)

func _emit_current_symbol_update():
	emit_signal("update_current_symbol", current_symbol, word.length())

func _update_stats():
	emit_signal("update_line_segments", turtle.lines.size())
	emit_signal("update_leaves", turtle.shapes_1.size())
	emit_signal("update_fruits", turtle.shapes_2.size())

func _draw():
	for line in turtle.lines:
		_draw_stem(line)
	for position in turtle.shapes_1:
		_draw_leave(position)
	for position in turtle.shapes_2:
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
		var applicable_productions = []
		if has_next_iteration() and has_next_rule(applicable_productions):
			next_rule(applicable_productions)
			generate_geometry()

func _on_FinishIteration():
	if has_next_iteration():
		while not is_iteration_finished():
			var applicable_productions = []
			if has_next_rule(applicable_productions):
				next_rule(applicable_productions)
		generate_geometry()
		if has_next_iteration():
			next_iteration()

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

func has_next_rule(applicable_productions: Array):
	current_symbol = grammar.find_next_rule(word, current_symbol, applicable_productions)
	_emit_current_symbol_update()
	return current_symbol < word.length()

func next_rule(applicable_productions: Array):
	if applicable_productions.empty():
		return
	var random_index: int = production_picker.pick(applicable_productions)
	var production: Production = applicable_productions[random_index]
	var successor: String = production.successor
	word = word_builder.apply_production(word, current_symbol, successor)
	current_symbol += successor.length()
	_emit_current_symbol_update()

func generate_geometry():
	var num_lines_before = turtle.lines.size()
	var num_leaves_before = turtle.shapes_1.size()
	var num_fruits_before = turtle.shapes_2.size()
	var initial_line_width = determine_line_width()
	turtle.generate_geometry(word, initial_line_width)
	var num_lines_after = turtle.lines.size()
	var num_leaves_after = turtle.shapes_1.size()
	var num_fruits_after = turtle.shapes_2.size()
	if num_lines_before != num_lines_after:
		emit_signal("update_line_segments", num_lines_after)
	if num_leaves_before != num_leaves_after:
		emit_signal("update_leaves", num_leaves_after)
	if num_fruits_before != num_fruits_after:
		emit_signal("update_fruits", num_fruits_after)
	update()

func determine_line_width():
	if dynamic_line_width:
		return (current_iteration+1)
	else:
		return 1.0

#func _on_randomize_cosmetics():
#	stem_thickness = randf()*9.9
#	fruit_radius = randf()*8
#	leaves_radius = randf()*8
#	color_stem = generateRandomRGB()
#	color_leaves = generateRandomRGB()
#	color_fruit = generateRandomRGB()

#func generateRandomRGB():
#	var result = Color()
#	result.r = randf()
#	result.g = randf()
#	result.b = randf()
#	return result

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
	grammar = preset.grammar
	preset.turtle_settings.start_position = start
	turtle.set_settings(preset.turtle_settings)
	turtle.forget_abilities()
	for ability in preset.turtle_abilities.enumerate_abilities():
		turtle.learn_ability(ability[0], ability[1])
	reset()

func _on_EditButton_button_up():
	Globals.grammar = grammar
	Globals.turtle_abilities = TurtleAbilities.new()
	Globals.turtle_abilities.add_abilities(turtle.enumerate_abilities())
	Globals.turtle_settings = turtle.get_settings()
	var error = get_tree().change_scene("res://source/scenes/editor/grammar_editor.tscn")
	if error:
		print("could not change scene: %s" % error)

func _on_FocusOriginButton_button_up():
	emit_signal("focus_camera", start)
