extends Button

func _on_button_up():
	randomize_color(get_node_or_null("../FruitColorPicker"))
	randomize_color(get_node_or_null("../LeavesColorPicker"))
	randomize_color(get_node_or_null("../StemColorPicker"))
	
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

