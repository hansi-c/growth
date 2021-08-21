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

class_name TurtleSettingsModel

enum AngleUnit {rad, deg}

var start_angle: float
var start_angle_unit = AngleUnit.rad
var turn_angle: float
var turn_angle_unit = AngleUnit.rad
var line_length: float
var width_falloff: float

func from_turtle_settings(settings: TurtleSettings):
	start_angle = settings.start_angle
	turn_angle = settings.turn_angle
	line_length = settings.line_length
	width_falloff = settings.width_falloff

func to_turtle_settings() -> TurtleSettings:
	var result = TurtleSettings.new()
	if start_angle_unit == AngleUnit.deg:
		result.start_angle = deg2rad(start_angle)
	else:
		result.start_angle = start_angle
	if turn_angle_unit == AngleUnit.deg:
		result.turn_angle = deg2rad(turn_angle)
	else:
		result.turn_angle = turn_angle
	result.line_length = line_length
	result.width_falloff = width_falloff
	return result
