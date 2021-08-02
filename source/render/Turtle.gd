class_name Turtle

var lines = []
var shapes_1 = []
var shapes_2 = []
var _state = TurtleState.new()
# maps from grammar symbol (a String) to Funcref
var _active_abilities = {}
var _control_abilities = {}
var _settings = TurtleSettings.new()

func set_settings(settings: TurtleSettings):
	_settings = settings

func get_settings() -> TurtleSettings:
	return _settings

func get_abilities() -> TurtleAbilities:
	return _collect_abilities(_active_abilities)
	
func get_control_abilities() -> TurtleAbilities:
		return _collect_abilities(_control_abilities)

func _collect_abilities(source: Dictionary) -> TurtleAbilities:
	var result = TurtleAbilities.new()
	for key in source:
		result.set_ability(key, source[key].get_function())
	return result

func set_abilities(abilities: TurtleAbilities):
	_create_abilities(_active_abilities, abilities)

func set_control_abilities(abilities: TurtleAbilities):
	_create_abilities(_control_abilities, abilities)

func _create_abilities(_target: Dictionary, source: TurtleAbilities):
	_target.clear()
	for pair in source.enumerate_abilities():
		var symbol = pair[0]
		var function_name = pair[1]
		_target[symbol] = _create_ability(function_name)

func _create_ability(ability: String) -> FuncRef:
	var call = FuncRef.new()
	call.set_instance(self)
	call.set_function(ability)
	return call

func generate_geometry(word: String, initial_line_width=1.0):
	reset()
	_initialize_state(initial_line_width)
	_process_word(word)

func reset():
	_state.reset()
	lines.clear()
	shapes_1.clear()
	shapes_2.clear()

func _initialize_state(initial_line_width: float):
	_state.set_width(initial_line_width)
	_state.set_position(_settings.start_position)
	_state.set_angle(_settings.start_angle)

func _process_word(word: String):
	for i in range(word.length()):
		var s = word[i]
		if _active_abilities.has(s):
			var ability = _active_abilities[s]
			ability.call_func()

### Abilities ###
# ability - rename with care!
func draw_line():
	if _state.angle != null:
		var direction = Vector2(cos(_state.angle), sin(_state.angle))
		var line_segment = _line_segment(_state.position, direction, _state.width)
		lines.append(line_segment)
		_state.position = line_segment.end
	else:
		push_error("invalid state")
	
func _line_segment(_start: Vector2, direction: Vector2, width: float) -> LineSegment:
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * _settings.line_length)
	result.width = width
	return result

# ability - rename with care!
func turn_ccw():
	_state.turn_counter_clockwise(_settings.turn_angle)

# ability - rename with care!
func turn_cw():
	_state.turn_clockwise(_settings.turn_angle)

# ability - rename with care!
func open_branch():
	_state.push_state()
	_state.width *= _settings.width_falloff

# ability - rename with care!
func close_branch():
	_state.pop_state()

# ability - rename with care!
func shape_1():
	shapes_1.append(_state.position + Vector2(0,2.0))
	
# ability - rename with care!
func shape_2():
	shapes_2.append(_state.position + Vector2(0,2.0))

func enumerate_potential_abilities() -> Array:
	return draw_abilities().keys() + control_abilities().keys()

func control_abilities() -> Dictionary:
	return {
		"turn_ccw"     : true,
		"turn_cw"      : true,
		"open_branch"  : true,
		"close_branch" : true,
	}

func draw_abilities() -> Dictionary:
	return {
		"draw_line" : true,
		"shape_1"   : true,
		"shape_2"   : true
	}
