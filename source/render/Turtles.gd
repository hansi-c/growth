extends Node

func default_abilities() -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", "draw_line")
	result.add_ability("-", "turn_cw")
	result.add_ability("+", "turn_ccw")
	result.add_ability("[", "open_branch")
	result.add_ability("]", "close_branch")
	return result

func wheat_abilities() -> TurtleAbilities:
	var result = default_abilities()
	result.add_ability("A", "shape_1")
	result.add_ability("B", "shape_2")
	return result

func sierpinski_abilities() -> TurtleAbilities:
	var result = default_abilities()
	result.add_ability("G", "draw_line")
	return result

func wheat_settings() -> TurtleSettings:
	var result = TurtleSettings.new()
	result.start_angle = Vector2.UP.angle() + deg2rad(25.0)
	result.turn_angle = deg2rad(25.0)
	result.line_length = 4.0
	result.width_falloff = 0.66
	return result

func sierpinski_120_settings() -> TurtleSettings:
	var result = TurtleSettings.new()
	result.start_angle = -deg2rad(120.0)
	result.turn_angle = -deg2rad(120.0)
	result.line_length = 40.0
	result.width_falloff = 1.0
	return result

func sierpinski_60_settings() -> TurtleSettings:
	var result = TurtleSettings.new()
	result.start_angle = Vector2.UP.angle()
	result.turn_angle = -deg2rad(60.0)
	result.line_length = 40.0
	result.width_falloff = 1.0
	return result
	
#func wheat():
#	var config = TurtleConfig.new()
#	config.start_angle = Vector2.UP.angle() + deg2rad(25.0)
#	config.turn_angle = deg2rad(25.0)
#	config.line_length = 4.0
#	config.width_falloff = 0.66
#	config.abilities["F"] = "draw_line"
#	config.abilities["-"] = "turn_cw"
#	config.abilities["+"] = "turn_ccw"
#	config.abilities["["] = "open_branch"
#	config.abilities["]"] = "close_branch"
#	config.abilities["A"] = "shape_1"
#	config.abilities["B"] = "shape_2"
#	return config
	
#func sierpinski_120():
#	var config = TurtleConfig.new()
#	config.start_angle = -deg2rad(120.0)#Vector2.UP.angle()
#	config.turn_angle = -deg2rad(120.0)
#	config.line_length = 40.0
#	config.width_falloff = 1.0
#	config.abilities["F"] = "draw_line"
#	config.abilities["G"] = "draw_line"
#	config.abilities["-"] = "turn_cw"
#	config.abilities["+"] = "turn_ccw"
#	return config
#
#func sierpinski_60():
#	var config = TurtleConfig.new()
#	config.start_angle = Vector2.UP.angle()
#	config.turn_angle = -deg2rad(60.0)
#	config.line_length = 40.0
#	config.width_falloff = 1.0
#	config.abilities["F"] = "draw_line"
#	config.abilities["G"] = "draw_line"
#	config.abilities["-"] = "turn_cw"
#	config.abilities["+"] = "turn_ccw"
#	return config
#
#func default_config():
#	var config = TurtleConfig.new()
#	config.abilities["F"] = "draw_line"
#	config.abilities["-"] = "turn_cw"
#	config.abilities["+"] = "turn_ccw"
#	config.abilities["["] = "open_branch"
#	config.abilities["]"] = "close_branch"
#	return config
