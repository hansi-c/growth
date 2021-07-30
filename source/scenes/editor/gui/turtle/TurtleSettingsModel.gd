class_name TurtleSettingsModel

enum AngleUnit {rad, deg}

var start_angle: float
var start_angle_unit = AngleUnit.rad
var turn_angle: float
var turn_angle_unit = AngleUnit.rad
var line_length: float
var width_falloff: float

func from_turtle_settings(settings: TurtleSettings):
	start_angle = settings.start_angle
	turn_angle = settings.turn_angle
	line_length = settings.line_length
	width_falloff = settings.width_falloff

func to_turtle_settings() -> TurtleSettings:
	var result = TurtleSettings.new()
	if start_angle_unit == AngleUnit.deg:
		result.start_angle = deg2rad(start_angle)
	else:
		result.start_angle = start_angle
	if turn_angle_unit == AngleUnit.deg:
		result.turn_angle = deg2rad(turn_angle)
	else:
		result.turn_angle = turn_angle
	result.line_length = line_length
	result.width_falloff = width_falloff
	return result
