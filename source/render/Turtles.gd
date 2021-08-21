extends Node

func default_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", TurtleAbilities.DRAW_LINE)
	add_control_abilities(result, grammar.control_symbols)
	return result

func add_control_abilities(result: TurtleAbilities,
	control_symbols: ControlSymbols):
	result.add_ability(control_symbols.get_symbol(
		TurtleAbilities.TURN_CW), TurtleAbilities.TURN_CW)
	result.add_ability(control_symbols.get_symbol(
		TurtleAbilities.TURN_CCW), TurtleAbilities.TURN_CCW)
	result.add_ability(control_symbols.get_symbol(
		TurtleAbilities.OPEN_BRANCH), TurtleAbilities.OPEN_BRANCH)
	result.add_ability(control_symbols.get_symbol(
		TurtleAbilities.CLOSE_BRANCH), TurtleAbilities.CLOSE_BRANCH)

func wheat_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", TurtleAbilities.DRAW_LINE)
	result.add_ability("A", TurtleAbilities.SHAPE_1)
	result.add_ability("B", TurtleAbilities.SHAPE_2)
	add_control_abilities(result, grammar.control_symbols)
	return result

func sierpinski_abilities(grammar: ILGrammar) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.add_ability("F", TurtleAbilities.DRAW_LINE)
	result.add_ability("G", TurtleAbilities.DRAW_LINE)
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
