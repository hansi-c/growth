extends TextureRect

var drag_handler = DragHandler.new()

func is_inside_shape(position: Vector2) -> bool:
	var image: Image = texture.get_data()
	image.lock()
	var color: Color = image.get_pixelv(position)
	image.unlock()
	print(image)
	print("hi %s %s %s" % [str(name), position, color])
	return color.a != 0

#func _draw():
#	var center = get_size()/2
#	draw_circle(center, center.x, Color.black)


func _on_self_gui_input(event):
	drag_handler.handle_drag(event, self)
