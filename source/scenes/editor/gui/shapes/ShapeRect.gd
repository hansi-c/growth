extends ColorRect
class_name ShapeRect

var drag_handler = DragHandler.new()

func _on_self_gui_input(event):
	drag_handler.handle_drag(event, self)

func is_inside_shape(_position:Vector2) -> bool:
	return true


func _on_RotationSlider_value_changed(value):
	set_rotation_degrees(value)
#	set_rotation(-value)
