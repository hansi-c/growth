extends ShapeConfiguration
class_name CircleConfiguration

func draw(target: CanvasItem, position: Vector2, _angle: float=0.0):
	target.draw_circle(position, _scale, _color)
