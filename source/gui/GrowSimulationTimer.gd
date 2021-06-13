extends Timer

func _on_PlayButton_toggled(button_pressed):
	set_paused(not button_pressed)


func _on_ZoomVScrollBar_value_changed(value):
	wait_time = value
