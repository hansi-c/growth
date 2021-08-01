extends Button

func _on_button_up():
	var stem_thickness = 0.1 + randf()*9.9
	var fruit_radius = randf()*8
	var leaves_radius = randf()*8
	randomize_size(get_node_or_null("../StemThicknessSlider"), stem_thickness)
	randomize_size(get_node_or_null("../FruitRadiusSlider"), fruit_radius)
	randomize_size(get_node_or_null("../LeafRadiusSlider"), leaves_radius)
	
func randomize_size(node, value):
	node.set_value(value)
	node.emit_signal("value_changed", value)
