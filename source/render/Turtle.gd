# growth - Lindenmayer Systems implemented in Godot
# Copyright (C) 2021  Christoph Czurda <rdssdf.fd@gmx.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

class_name Turtle

var lines = []
var shapes_1 = []
var shapes_2 = []
var _state = TurtleState.new()
# maps from alphabet symbol to FuncRef
var _abilities: Dictionary = {}
var _settings = TurtleSettings.new()

func set_settings(settings: TurtleSettings):
	_settings = settings

func get_settings() -> TurtleSettings:
	return _settings

func learn_ability(symbol: String, function: String):
	var ability: FuncRef = _create_funcref(function)
	_abilities[symbol] = ability

func _create_funcref(ability: String) -> FuncRef:
	var call = FuncRef.new()
	call.set_instance(self)
	call.set_function(ability)
	return call

func generate_geometry(word: String, initial_line_width=1.0):
	reset()
	_initialize_state(initial_line_width)
	_process_word(word)

func forget_abilities():
	_abilities.clear()

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
		if _abilities.has(s):
			var ability = _abilities[s]
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

func enumerate_abilities() -> Dictionary:
	var result = {}
	for key in _abilities:
		var function: String = _abilities[key].function
		result[key] = function
	return result
