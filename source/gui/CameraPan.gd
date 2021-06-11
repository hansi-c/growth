extends Node2D


var _dragging = false
#var _receive_drag = true

signal camera_panning(relative)

func _unhandled_input(event):
#	print("unhandled input event: %s" % event.as_text())
	if event is InputEventMouseButton:
		_dragging = event.pressed
	if _dragging and event is InputEventMouseMotion:
		emit_signal("camera_panning", event.relative)
