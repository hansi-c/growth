extends ColorRect
class_name ShapeRect

var dragging = false
var drag_offset = Vector2.ZERO

func _on_self_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() \
	and event.get_button_index() == 1:
		var local_position = event.get_position()
		if _is_inside_shape(local_position):
			dragging = true
			drag_offset = local_position

func _is_inside_shape(position:Vector2) -> bool:
	return true

func _input(event):
	if dragging:
		if event is InputEventMouseMotion:
			var global_position = event.get_global_position()
			set_global_position(global_position - drag_offset)
		elif event is InputEventMouseButton and not event.is_pressed():
			dragging = false
