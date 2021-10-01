extends ColorRect

var dragging = false
var drag_offset = Vector2.ZERO

func _draw():
	var center = get_size()/2
	draw_circle(center, center.x, Color.black)

func _on_self_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed() \
	and event.get_button_index() == 1:
		var local_position = event.get_position()
		if _is_inside_circle(local_position):
			dragging = true
			drag_offset = local_position

func _is_inside_circle(position:Vector2) -> bool:
	var center = get_size()/2
	return center.distance_to(position) <= center.x

func _input(event):
	if dragging:
		if event is InputEventMouseMotion:
			var global_position = event.get_global_position()
			set_global_position(global_position - drag_offset)
		elif event is InputEventMouseButton and not event.is_pressed():
			dragging = false
