extends Node

func default_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", "draw_line")
	add_control_abilities(result, grammar.control_symbols)
	return result

func add_control_abilities(result: TurtleAbilities, control_symbols: ControlSymbols):
	result.add_ability(control_symbols.get_rotate_cw(), "turn_cw")
	result.add_ability(control_symbols.get_rotate_ccw(), "turn_ccw")
	result.add_ability(control_symbols.get_open_branch(), "open_branch")
	result.add_ability(control_symbols.get_close_branch(), "close_branch")

func wheat_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", "draw_line")
	result.add_ability("A", "shape_1")
	result.add_ability("B", "shape_2")
	add_control_abilities(result, grammar.control_symbols)
	return result

func sierpinski_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", "draw_line")
	result.add_ability("G", "draw_line")
	add_control_abilities(result, grammar.control_symbols)
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

func duplicate_abilities(abilities: TurtleAbilities) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	for pair in abilities.enumerate_abilities():
		result.add_ability(pair[0], pair[1])
	return result

func duplicate_settings(settings: TurtleSettings) -> TurtleSettings:
	var result = TurtleSettings.new()
	result.start_position = settings.start_position
	result.start_angle = settings.start_angle
	result.turn_angle = settings.turn_angle
	result.line_length = settings.line_length
	result.width_falloff = settings.width_falloff
	return result
