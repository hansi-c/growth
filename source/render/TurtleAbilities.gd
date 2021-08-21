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

class_name TurtleAbilities

const DRAW_LINE    = "draw_line"
const SHAPE_1      = "shape_1"
const SHAPE_2      = "shape_2"
const TURN_CW      = "turn_cw"
const TURN_CCW     = "turn_ccw"
const OPEN_BRANCH  = "open_branch"
const CLOSE_BRANCH = "close_branch"

# symbol -> ability
var _abilities: Dictionary = {}

func add_abilities(abilities: Dictionary):
	for key in abilities.keys():
		add_ability(key, abilities[key])

func add_ability(symbol: String, ability: String):
	_abilities[symbol] = ability

func remove_symbol(symbol: String):
	_abilities.erase(symbol)

func has_symbol(symbol: String) -> bool:
	return _abilities.has(symbol)

func get_ability(symbol: String) -> String:
	return _abilities[symbol]

func has_ability(symbol: String) -> bool:
	return _abilities.has(symbol)

# returns an array of arrays.
# the inner arrays have 2 entries: [symbol, ability]
func enumerate_abilities() -> Array:
	var result = []
	for key in _abilities:
		var pair = [key, _abilities[key]]
		result.append(pair)
	return result

func clear():
	_abilities.clear()

func _to_string() -> String:
	return str(enumerate_abilities())

const potential_user_abilities: Dictionary = {
	DRAW_LINE : "draw line",
	SHAPE_1   : "shape 1",
	SHAPE_2   : "shape 2"
}

const potential_control_abilities: Dictionary = {
	OPEN_BRANCH  : "open branch",
	CLOSE_BRANCH : "close branch",
	TURN_CCW     : "turn counterclockwise",
	TURN_CW      : "turn clockwise",
}

static func potential_abilities() -> Dictionary:
	var result = {}
	for key in potential_user_abilities:
		result[key] = potential_user_abilities[key]
	for key in potential_control_abilities:
		result[key] = potential_control_abilities[key]
	return result

static func is_control_ability(ability: String) -> bool:
	return potential_control_abilities.has(ability)

static func is_user_ability(ability: String) -> bool:
	return potential_user_abilities.has(ability)
