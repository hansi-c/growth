extends Node2D

var _dragging = false

signal camera_panning(relative)

func _input(event):
	if event is InputEventMouseButton:
		_dragging = event.pressed
	if _dragging and event is InputEventMouseMotion:
		emit_signal("camera_panning", event.relative)
