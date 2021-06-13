extends CanvasItem
class_name GrowContextFull

export var iterations = 6
export var start = Vector2(500, 400)
export var branch_length = 40.0
var current_iteration = 0
var current_symbol = 0
var word = ""
var grammar = Grammars.wheat_1l()
var _25degrees = deg2rad(25.0)
var start_angle = Vector2.UP.angle() + _25degrees
var turtle: Turtle
var color_fruit = Color.red
var color_leaves = Color.green
var color_stem = Color.brown
var leaves_radius = 3.0
var fruit_radius = 5.0
var stem_thickness = 1.0

signal max_iteration_reached()
signal update_current_iteration(text)
signal update_leaves(amount)
signal update_fruits(amount)
signal update_line_segments(amount)

func _ready():
	word = grammar.axiom
	initialize_turtle()
	update_stats()
	emit_iteration_update()

func initialize_turtle():
	turtle = Turtle.new()
	turtle.start = start
	turtle.start_angle = start_angle
	turtle.turn_degrees = _25degrees
	turtle.segment_length = branch_length

func emit_iteration_update():
	emit_signal("update_current_iteration", "%s/%s" % [current_iteration, iterations])

func update_stats():
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
		if has_next_rule():
			next_rule()
			generate_geometry()

func has_next_iteration():
	return current_iteration < iterations

func is_iteration_finished():
	return current_symbol >= word.length()

func next_iteration():
	current_symbol = 0
	current_iteration += 1
	emit_iteration_update()
	if not has_next_iteration():
		emit_signal("max_iteration_reached")

func has_next_rule():
	while current_symbol < word.length():
		var symbol = word[current_symbol]
		if grammar.productions.has(symbol):
			return true
		current_symbol += 1
	return false

func next_rule():
	word = grammar.apply_production(word, current_symbol)
	current_symbol += grammar.last_applied_production.successor.length()

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

func _on_FinishIteration():
	if has_next_iteration():
		while not is_iteration_finished() and has_next_rule():
			next_rule()
		generate_geometry()
		if has_next_iteration():
			next_iteration()

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
