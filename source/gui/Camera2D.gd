extends Camera2D

func _on_ZoomScrollBar_value_changed(value):
	zoom = Vector2(value, value)

func _on_camera_panning(relative):
	position -= relative
