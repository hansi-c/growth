extends Label

func _on_update_current_iteration(current, maximum):
	set_text("%s/%s" % [current, maximum])
