extends Camera2D

func _on_ZoomScrollBar_value_changed(value):
	zoom = Vector2(value, value)

func _on_camera_panning(relative):
	position -= relative * zoom

func _on_camera_reset():
	position = get_node("../PlantCanvas/GrowthStartPosition").position
	zoom = Vector2(1,1)

func _on_camera_zooming(zoom_change, mouse_pos):
	_zoom_at_point(zoom_change, mouse_pos)
	print ("signal detected")

func _zoom_at_point(zoom_change, mouse_position):
	zoom = zoom * zoom_change
	print (zoom_change)
	var delta_x = (mouse_position.x - global_position.x) * (zoom_change - 1)
	var delta_y = (mouse_position.y - global_position.y) * (zoom_change - 1)
	global_position.x = global_position.x - delta_x
	global_position.y = global_position.y - delta_y
