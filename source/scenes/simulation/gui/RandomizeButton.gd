extends Button

func on_button_pressed():
	var color_stem = generateRandomRGB()
	var color_leaves = generateRandomRGB()
	var color_fruit = generateRandomRGB()
	var stem_thickness = randf()*9.9
	var fruit_radius = randf()*8
	var leaves_radius = randf()*8

func generateRandomRGB():
	var result = Color()
	result.r = randf()
	result.g = randf()
	result.b = randf()
	return result
