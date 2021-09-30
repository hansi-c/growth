extends ShapeConfiguration
class_name ImageConfiguration

var _texture: Texture = load("res://assets/tomate.png")

func draw(target: CanvasItem, position: Vector2, angle: float=0.0):
#	target.draw_set_transform(Vector2.ZERO, angle, Vector2(_scale, _scale))
#	target.draw_texture(_texture, position)
	var rect = Rect2(position, _texture.get_size() * _scale)
	target.draw_texture_rect(_texture, rect, false)

func set_texture(texture: Texture):
	_texture = texture

func get_texture():
	return _texture
