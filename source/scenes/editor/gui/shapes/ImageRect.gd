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

func _on_FileSelect_texture_loaded(texture: Texture):
	set_texture(texture)
	var texture_size = texture.get_size()
	_set_size(texture_size)
	set_pivot_offset(texture_size/2)
	
func _on_RotationSlider_value_changed(value: float):
	set_rotation_degrees(-value)
