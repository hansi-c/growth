extends Node2D

var _left_edge: Vector2 = Vector2.ZERO
var _right_edge: Vector2 = Vector2.ZERO

func _ready():
	var parent = get_parent()
	if parent is ColorRect:
		var half = parent.get_size().x/2
		_left_edge = Vector2(-half, 0)
		_right_edge = Vector2(half+1, 0)

func _draw():
	draw_line(_left_edge, _right_edge, Color.black, 5.0)



#var renderer: ShapeRenderer
#
#func _on_ShapeSourceButton_circle_selected():
#	draw_circle(position, 100.0, Color.white)
#
#func _on_ShapeSourceButton_rectangle_selected():
#	renderer = RectangleRenderer.new()
#
#func _on_ShapeSourceButton_triangle_selected():
#	pass
#
#func _draw():
#	pass
#
#class ShapeRenderer:
#	var origin: Vector2
#
#	func render():
#		pass
#
#class RectangleRenderer extends ShapeRenderer:
#
#	func render():
#		var rect = Rect2(Vector2(origin-origin/2), Vector2.ONE*100)
##		draw_rect(rect, Color.white)
