extends Node2D

signal camera_zooming(zoom_factor, relative)

var zoom_factor = 1.1

func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position
			if event.button_index == BUTTON_WHEEL_UP:
				emit_signal("camera_zooming", 1/zoom_factor, mouse_position)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				emit_signal("camera_zooming", zoom_factor, mouse_position)
