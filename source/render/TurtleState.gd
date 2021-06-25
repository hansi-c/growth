class_name TurtleState

var positions = []
var angles = []
var widths = []
var position = Vector2.ZERO
var angle = 0
var width = 0

func set_position(_position: Vector2):
	position = _position

func set_angle(_angle: float):
	angle = _angle

func set_width(_width: float):
	width = _width

func turn_counter_clockwise(degrees_radians: float):
	angle -= degrees_radians

func turn_clockwise(degrees_radians: float):
	angle += degrees_radians

func change_width(by:float = 1.0):
	width += by

func push_state():
	positions.push_back(position)
	angles.push_back(angle)
	widths.push_back(width)

func pop_state():
	position = positions.pop_back()
	angle = angles.pop_back()
	width = widths.pop_back()

func reset():
	positions.clear()
	angles.clear()
	widths.clear()
	position = Vector2.ZERO
	angle = 0
	width = 0
