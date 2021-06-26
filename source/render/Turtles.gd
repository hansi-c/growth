extends Node

func wheat():
	var config = TurtleConfig.new()
	config.start_angle = Vector2.UP.angle() + deg2rad(25.0)
	config.turn_angle = deg2rad(25.0)
	config.line_length = 4.0
	config.width_falloff = 0.66
	config.abilities["F"] = "draw_line"
	config.abilities["-"] = "turn_cw"
	config.abilities["+"] = "turn_ccw"
	config.abilities["["] = "open_branch"
	config.abilities["]"] = "close_branch"
	config.abilities["A"] = "shape_1"
	config.abilities["B"] = "shape_2"
	return config
	
func sierpinski_120():
	var config = TurtleConfig.new()
	config.start_angle = -deg2rad(120.0)#Vector2.UP.angle()
	config.turn_angle = -deg2rad(120.0)
	config.line_length = 40.0
	config.width_falloff = 1.0
	config.abilities["F"] = "draw_line"
	config.abilities["G"] = "draw_line"
	config.abilities["-"] = "turn_cw"
	config.abilities["+"] = "turn_ccw"
	return config

func sierpinski_60():
	var config = TurtleConfig.new()
	config.start_angle = Vector2.UP.angle()
	config.turn_angle = -deg2rad(60.0)
	config.line_length = 40.0
	config.width_falloff = 1.0
	config.abilities["F"] = "draw_line"
	config.abilities["G"] = "draw_line"
	config.abilities["-"] = "turn_cw"
	config.abilities["+"] = "turn_ccw"
	return config

func default_config():
	var config = TurtleConfig.new()
	config.abilities["F"] = "draw_line"
	config.abilities["-"] = "turn_cw"
	config.abilities["+"] = "turn_ccw"
	config.abilities["["] = "open_branch"
	config.abilities["]"] = "close_branch"
	return config
