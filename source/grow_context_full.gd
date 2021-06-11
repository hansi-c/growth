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

func _ready():
	word = grammar.axiom
	initialize_turtle()

func initialize_turtle():
	turtle = Turtle.new()
	turtle.start = start
	turtle.start_angle = start_angle
	turtle.turn_degrees = _25degrees
	turtle.segment_length = branch_length

func _draw():
	for branch in turtle.lines:
		draw_line(branch.start, branch.end, color_stem, branch.width * stem_thickness)
	for circle in turtle.leaves:
		draw_circle(circle, leaves_radius, color_leaves)
	for fruit in turtle.fruits:
		draw_circle(fruit, fruit_radius, color_fruit)

func _on_Timer_timeout():
	if has_next_iteration():
		if is_iteration_finished():
			next_iteration()
		if has_next_rule():
			next_rule()

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
		if grammar.productions.has(symbol):
			return true
		current_symbol += 1
	return false

func next_rule():
	word = grammar.apply_production(word, current_symbol)
	current_symbol += grammar.last_applied_production.successor.length()
	turtle.generate_lines(word, current_iteration)
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
