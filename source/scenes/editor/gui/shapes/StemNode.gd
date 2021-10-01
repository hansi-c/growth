extends Node2D

var _left_edge: Vector2 = Vector2.ZERO

func _ready():
	var parent = get_parent().get_parent()
	if parent is Control:
		var half_length = (parent.get_size()/2).length()
		_left_edge = Vector2(-half_length, 0)

func _draw():
	draw_line(_left_edge, Vector2.ZERO, Color.black, 1.0)

func _on_StemRotationSlider_value_changed(value):
	rotation = value
