extends Timer

func _on_PlayButton_toggled(button_pressed):
	set_paused(not button_pressed)
