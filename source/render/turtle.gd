class_name Turtle

var lines = []
var leaves = []
var fruits = []
var state = TurtleState.new()
# maps from grammar symbol (a String) to Funcref
var _abilities = {}
var _settings = TurtleSettings.new()
#var _config: TurtleConfig
#var start_position: Vector2

#func set_config(config: TurtleConfig):
#	_config = config
#	for key in _config.abilities:
#		add_ability(key, _config.abilities[key])

#func get_config() -> TurtleConfig:
#	return _config

func generate_geometry(word: String, initial_width=1.0):
	lines.clear()
	leaves.clear()
	fruits.clear()
	state.reset()
	state.set_width(initial_width)
	state.set_position(_settings.start_position)
	state.set_angle(_settings.start_angle)
#	print(_abilities)
	for i in range(word.length()):
		var s = word[i]
		if _abilities.has(s):
			var ability = _abilities[s]
			ability.call_func()
#func generate_geometry(word: String, start_position: Vector2, initial_width: float):
#	lines.clear()
#	leaves.clear()
#	fruits.clear()
#	state.set_width(initial_width)
#	state.set_position(start_position)
#	state.set_angle(_config.start_angle)
#
#	for i in range(word.length()):
#		var s = word[i]
#		if abilities.has(s):
#			var ability = abilities[s]
#			ability.call_func()

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

func draw_line():
	var direction = Vector2(cos(state.angle), sin(state.angle))
	var line_segment = _line_segment(state.position, direction, state.width)
	lines.append(line_segment)
	state.position = line_segment.end
	
func _line_segment(_start, direction, width):
	var result = LineSegment.new()
	result.start = _start
	result.end = _start + (direction * _settings.line_length)
	result.width = width
	return result
	
func turn_ccw():
	state.turn_counter_clockwise(_settings.turn_angle)

func turn_cw():
	state.turn_clockwise(_settings.turn_angle)

func open_branch():
	state.push_state()
	state.width *= _settings.width_falloff

func close_branch():
	state.pop_state()

func shape_1():
	leaves.append(state.position + Vector2(0,2.0))
	
func shape_2():
	fruits.append(state.position + Vector2(0,2.0))

func reset():
	state.reset()
	lines.clear()
	leaves.clear()
	fruits.clear()
