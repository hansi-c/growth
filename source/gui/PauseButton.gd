extends Button

func _on_PlayButton_toggled(button_pressed):
	if button_pressed:
		text = "Playing"
	else:
		text = "Paused"
