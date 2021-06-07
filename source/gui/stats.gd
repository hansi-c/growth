extends GridContainer

func _on_update_iteration(value):
	get_node("iteration_value").set_text(str(value))

func _on_update_word_length(value):
	get_node("word_length_value").set_text(str(value))

func _on_update_current_symbol(value):
	get_node("current_symbol_value").set_text(str(value))

func _on_update_lines_drawn(value):
	get_node("lines_drawn_value").set_text(str(value))

func _on_update_last_rule(value):
	get_node("last_rule_value").set_text(str(value))

func _on_update_angle(value):
	get_node("angle_value").set_text(str(value))
