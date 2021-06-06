extends Camera2D

func _on_ZoomScrollBar_value_changed(value):
	print("value %s" % value)
	print("zoom %s" % zoom)
#	zoom += value
	zoom = Vector2(value, value)
