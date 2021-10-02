extends TextureRect

var drag_handler = DragHandler.new()

func _on_self_gui_input(event):
	drag_handler.handle_drag(event, self)

func is_inside_shape(position: Vector2) -> bool:
	var image: Image = texture.get_data()
	image.lock()
	var color: Color = image.get_pixelv(position)
	image.unlock()
	return color.a > 0.0
