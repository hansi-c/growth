extends Node

func wheat():
	var config = TurtleConfig.new()
	config.start_angle = Vector2.UP.angle() + deg2rad(25.0)
	config.turn_angle = deg2rad(25.0)
	config.line_length = 4.0
	config.width_falloff = 0.66
	return config
	
func sierpinski_120():
	var config = TurtleConfig.new()
	config.start_angle = -deg2rad(120.0)#Vector2.UP.angle()
	config.turn_angle = -deg2rad(120.0)
	config.line_length = 40.0
	config.width_falloff = 1.0
	return config

func sierpinski_60():
	var config = TurtleConfig.new()
	config.start_angle = Vector2.UP.angle()
	config.turn_angle = -deg2rad(60.0)
	config.line_length = 40.0
	config.width_falloff = 1.0
	return config
