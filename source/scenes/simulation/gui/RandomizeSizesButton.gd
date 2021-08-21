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
	var stem_thickness = 0.1 + randf()*9.9
	var fruit_radius = randf()*8
	var leaves_radius = randf()*8
	randomize_size(get_node_or_null("../StemThicknessSlider"), stem_thickness)
	randomize_size(get_node_or_null("../FruitRadiusSlider"), fruit_radius)
	randomize_size(get_node_or_null("../LeafRadiusSlider"), leaves_radius)
	
func randomize_size(node, value):
	node.set_value(value)
	node.emit_signal("value_changed", value)
