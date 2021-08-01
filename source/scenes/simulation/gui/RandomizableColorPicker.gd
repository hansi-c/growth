extends ColorPickerButton

func _on_random_color():
	var c = generateRandomRGB()
	set_pick_color(c)
	emit_signal("color_changed", c)
	
func generateRandomRGB():
	var result = Color()
	result.r = randf()
	result.g = randf()
	result.b = randf()
	return result
