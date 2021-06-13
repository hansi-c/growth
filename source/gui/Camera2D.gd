extends Camera2D

var zoom_speed = 0.05

func _process(delta):
	var zoom_limit = 1.0
	if zoom.x <= zoom_limit :
		if Input.is_action_just_released("wheel_up"):
			zoom = zoom - Vector2(zoom_speed,zoom_speed)
		if Input.is_action_just_released("wheel_down"):
			zoom = zoom + Vector2(zoom_speed,zoom_speed)
	else:
		zoom = Vector2(1,1)

func _on_ZoomScrollBar_value_changed(value):
	zoom = Vector2(value, value)

func _on_camera_panning(relative):
	position -= relative
