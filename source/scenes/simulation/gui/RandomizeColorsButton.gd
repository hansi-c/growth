extends Button

func _on_button_up():
	randomize_color(get_node_or_null("../FruitColorPicker"))
	randomize_color(get_node_or_null("../LeavesColorPicker"))
	randomize_color(get_node_or_null("../StemColorPicker"))
	var stem_thickness = 0.1 + randf()*9.9
	var fruit_radius = randf()*8
	var leaves_radius = randf()*8
	
func randomize_color(node):
	var _color = generateRandomRGB()
	node.set_pick_color(_color)
	node.emit_signal("color_changed", _color)

func generateRandomRGB():
	var result = Color()
	result.r = randf()
	result.g = randf()
	result.b = randf()
	return result

