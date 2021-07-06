class_name Turtle

var lines = []
var shapes_1 = []
var shapes_2 = []
var _state = TurtleState.new()
# maps from grammar symbol (a String) to Funcref
var _active_abilities = {}
var _settings = TurtleSettings.new()

func set_settings(settings: TurtleSettings):
	_settings = settings

func get_settings() -> TurtleSettings:
	return _settings

func set_abilities(abilities: TurtleAbilities):
	_active_abilities.clear()
	for pair in abilities.enumerate_abilities():
		add_ability(pair[0], pair[1])

func get_abilities() -> TurtleAbilities:
	var result = TurtleAbilities.new()
	for key in _active_abilities:
		result.set_ability(key, _active_abilities[key].get_function())
	return result

func add_ability(symbol: String, ability: String):
	var call = FuncRef.new()
	call.set_instance(self)
	call.set_function(ability)
	_active_abilities[symbol] = call

func generate_geometry(word: String, initial_line_width=1.0):
	reset()
	_initialize_state(initial_line_width)
	_process_word(word)

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

func draw_line():
	var direction = Vector2(cos(_state.angle), sin(_state.angle))
	var line_segment = _line_segment(_state.position, direction, _state.width)
	lines.append(line_segment)
	_state.position = line_segment.end
	
func _line_segment(_start: Vector2, direction: Vector2, width: float) -> LineSegment:
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * _settings.line_length)
	result.width = width
	return result
	
func turn_ccw():
	_state.turn_counter_clockwise(_settings.turn_angle)

func turn_cw():
	_state.turn_clockwise(_settings.turn_angle)

func open_branch():
	_state.push_state()
	_state.width *= _settings.width_falloff

func close_branch():
	_state.pop_state()

func shape_1():
	shapes_1.append(_state.position + Vector2(0,2.0))
	
func shape_2():
	shapes_2.append(_state.position + Vector2(0,2.0))

func reset():
	_state.reset()
	lines.clear()
	shapes_1.clear()
	shapes_2.clear()

func enumerate_potential_abilities() -> Array:
	return [
		"draw_line",
		"turn_ccw",
		"turn_cw",
		"open_branch",
		"close_branch",
		"shape_1",
		"shape_2"
	]
