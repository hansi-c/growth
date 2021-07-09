extends Node

func default_abilities(alphabet: Dictionary) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	if alphabet.has("F"):
		result.set_ability("F", "draw_line")
	if alphabet.has("-"):
		result.set_ability("-", "turn_cw")
	if alphabet.has("+"):
		result.set_ability("+", "turn_ccw")
	if alphabet.has("["):
		result.set_ability("[", "open_branch")
	if alphabet.has("]"):
		result.set_ability("]", "close_branch")
	return result

func wheat_abilities() -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.set_ability("F", "draw_line")
	result.set_ability("-", "turn_cw")
	result.set_ability("+", "turn_ccw")
	result.set_ability("[", "open_branch")
	result.set_ability("]", "close_branch")
	result.set_ability("A", "shape_1")
	result.set_ability("B", "shape_2")
	return result

func sierpinski_abilities() -> TurtleAbilities:
	var result = TurtleAbilities.new()
	result.set_ability("F", "draw_line")
	result.set_ability("-", "turn_cw")
	result.set_ability("+", "turn_ccw")
	result.set_ability("G", "draw_line")
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
		result.set_ability(pair[0], pair[1])
	return result

func duplicate_settings(settings: TurtleSettings) -> TurtleSettings:
	var result = TurtleSettings.new()
	result.start_position = settings.start_position
	result.start_angle = settings.start_angle
	result.turn_angle = settings.turn_angle
	result.line_length = settings.line_length
	result.width_falloff = settings.width_falloff
	return result
