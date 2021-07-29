extends Label

func _on_update_current_symbol(current, maximum):
	set_text("%s/%s" % [current, maximum])
