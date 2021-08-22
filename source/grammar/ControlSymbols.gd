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

class_name ControlSymbols

var _dictionary = {
	TurtleAbilities.TURN_CW      : "-",
	TurtleAbilities.TURN_CCW     : "+",
	TurtleAbilities.OPEN_BRANCH  : "[",
	TurtleAbilities.CLOSE_BRANCH : "]"
}

func has_ability(ability: String) -> bool:
	return _dictionary.has(ability)

func has_symbol(symbol: String) -> bool:
	return _dictionary.values().has(symbol)

func get_symbol(ability: String):
	return _dictionary[ability]

func set_symbol(ability: String, symbol: String):
	_dictionary[ability] = symbol

func get_branching_symbols() -> BranchingSymbols:
	return BranchingSymbols.new(_dictionary[TurtleAbilities.OPEN_BRANCH],
	 _dictionary[TurtleAbilities.CLOSE_BRANCH])

func enumerate() -> Array:
	return _dictionary.values()
#
func enumerate_dictionary() -> Dictionary:
	return _dictionary.duplicate()
	
func _to_string() -> String:
	return ""
