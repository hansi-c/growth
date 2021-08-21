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

class_name TurtleState

var positions = []
var angles = []
var widths = []
var position = Vector2.ZERO
var angle = 0.0
var width = 0.0

func set_position(_position: Vector2):
	position = _position

func set_angle(_angle: float):
	angle = _angle

func set_width(_width: float):
	width = _width

func turn_counter_clockwise(degrees_radians: float):
	angle -= degrees_radians

func turn_clockwise(degrees_radians: float):
	angle += degrees_radians

func change_width(by:float = 1.0):
	width += by

func push_state():
	positions.push_back(position)
	angles.push_back(angle)
	widths.push_back(width)

func pop_state():
	position = positions.pop_back()
	if not position:
		push_error("cannot pop empty stack")
	angle = angles.pop_back()
	width = widths.pop_back()

func reset():
	positions.clear()
	angles.clear()
	widths.clear()
	position = Vector2.ZERO
	angle = 0
	width = 0

func _to_string():
	return "position: %s\nangle: %s\nwidth: %s\npositions: %s\nangles: %s\nwidths: %s" % [
		position, angle, width, positions, angles, widths
	]
