class_name TurtleConfig

var start_angle = -PI/2
var turn_angle = PI/4
var line_length = 10.0
var width_falloff = 1.0
# maps from grammar symbol to function name, like this:
# config.abilities["F"] = "draw_line"
var abilities = {}

func _to_string():
	return "start angle: %s\nturn angle: %s\nline length: %s\nwidth falloff: %s\nabilities: %s" % [
		start_angle, turn_angle, line_length, width_falloff, abilities]
