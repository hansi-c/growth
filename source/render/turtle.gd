class_name Turtle

var lines = []
var leaves = []
var fruits = []
var _state = TurtleState.new()
# maps from grammar symbol (a String) to Funcref
var _abilities = {}
var _settings = TurtleSettings.new()

func set_settings(settings: TurtleSettings):
	_settings = settings

func get_settings():
	return _settings

func set_abilities(abilities: TurtleAbilities):
	for pair in abilities.enumerate_abilities():
		add_ability(pair[0], pair[1])

func get_abilities():
	var result = TurtleAbilities.new()
	for key in _abilities:
		result.add_ability(key, _abilities[key].get_function())
	return result

func add_ability(symbol: String, ability: String):
	var call = FuncRef.new()
	call.set_instance(self)
	call.set_function(ability)
	_abilities[symbol] = call

func generate_geometry(word: String, initial_line_width=1.0):
	reset()
	_initialize_state(initial_line_width)
	_process_word(word)

func _initialize_state(initial_line_width):
	_state.set_width(initial_line_width)
	_state.set_position(_settings.start_position)
	_state.set_angle(_settings.start_angle)

func _process_word(word: String):
	for i in range(word.length()):
		var s = word[i]
		if _abilities.has(s):
			var ability = _abilities[s]
			ability.call_func()

func draw_line():
	var direction = Vector2(cos(_state.angle), sin(_state.angle))
	var line_segment = _line_segment(_state.position, direction, _state.width)
	lines.append(line_segment)
	_state.position = line_segment.end
	
func _line_segment(_start, direction, width):
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
	leaves.append(_state.position + Vector2(0,2.0))
	
func shape_2():
	fruits.append(_state.position + Vector2(0,2.0))

func reset():
	_state.reset()
	lines.clear()
	leaves.clear()
	fruits.clear()
