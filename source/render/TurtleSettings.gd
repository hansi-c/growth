class_name TurtleSettings

var start_position = Vector2(0.0, 0.0)
var start_angle = -PI/2
var turn_angle = PI/4
var line_length = 10.0
#var initial_width = 1.0
var width_falloff = 1.0

func _to_string() -> String:
	return "start angle: %s, turn angle: %s, line length: %s, width falloff %s" % [start_angle, turn_angle, line_length, width_falloff]
