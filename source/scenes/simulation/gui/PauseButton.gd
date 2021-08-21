extends TextureButton

func _on_FinishIterationButton_button_up():
	if pressed:
		set_pressed(false)

func _on_max_iteration_reached():
	set_disabled(true)


func _on_iterations_reset():
	set_disabled(false)
