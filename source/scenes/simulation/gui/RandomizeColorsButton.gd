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

extends Button

func _on_button_up():
	randomize_color(get_node_or_null("../FruitColorPicker"))
	randomize_color(get_node_or_null("../LeavesColorPicker"))
	randomize_color(get_node_or_null("../StemColorPicker"))
	
func randomize_color(node):
	var _color = generateRandomRGB()
	node.set_pick_color(_color)
	node.emit_signal("color_changed", _color)

func generateRandomRGB():
	var result = Color()
	result.r = randf()
	result.g = randf()
	result.b = randf()
	return result

