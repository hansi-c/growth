extends ShapeRect

func is_inside_shape(position:Vector2) -> bool:
	var center = get_size()/2
	return center.distance_to(position) <= center.x

func _draw():
	var center = get_size()/2
	draw_circle(center, center.x, Color.black)
