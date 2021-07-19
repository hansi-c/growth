extends Button

func _on_PlayButton_toggled(button_pressed):
	if button_pressed:
		text = "Playing"
	else:
		text = "Paused"


func _on_FinishIterationButton_button_up():
	if pressed:
		set_pressed(false)

func _on_max_iteration_reached():
#	set_pressed(false)
	set_disabled(true)


func _on_iterations_reset():
	set_disabled(false)
