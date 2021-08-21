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

class_name TurtleSettings

var start_position = Vector2(0.0, 0.0)
var start_angle = -PI/2
var turn_angle = PI/4
var line_length = 10.0
#var initial_width = 1.0
var width_falloff = 1.0

func _to_string() -> String:
	return "start angle: %s, turn angle: %s, line length: %s, width falloff %s" % [start_angle, turn_angle, line_length, width_falloff]
