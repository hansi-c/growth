class_name ShapeConfiguration

var _scale: float = 1.0
var _color: Color = Color.black
#var offset
#var angle

func draw(_target: CanvasItem, _position: Vector2, _angle: float=0.0):
	pass

#class RectangleConfiguration extends ShapeConfiguration:
#	func draw(target: CanvasItem, position: Vector2, angle: float):
#		pass

func set_scale(scale: float):
	_scale = scale

func get_scale():
	return _scale

func set_color(color: Color):
	_color = color
	
func get_color():
	return _color
