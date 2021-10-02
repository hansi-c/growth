class_name DragHandler

var _dragging = false
var _drag_offset = Vector2.ZERO

func handle_drag(event: InputEvent, control):
	if is_left_mouse_pressed(event):
		var local_position = event.get_position()
		if control.is_inside_shape(local_position):
			_dragging = true
			_drag_offset = event.get_position() * control.get_scale()
	elif _dragging:
		if event is InputEventMouseMotion:
			var global_position = event.get_global_position()
			control.set_global_position(global_position - _drag_offset)
		elif is_left_mouse_released(event):
			_dragging = false

func is_left_mouse_pressed(event: InputEvent) -> bool:
	return is_left_mouse_button(event, true)

func is_left_mouse_released(event: InputEvent) -> bool:
	return is_left_mouse_button(event, false)
	
func is_left_mouse_button(event: InputEvent, pressed: bool):
	return event is InputEventMouseButton \
		and event.get_button_index() == 1 \
		and event.is_pressed() == pressed
