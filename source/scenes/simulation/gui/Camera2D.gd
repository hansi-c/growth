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

extends Camera2D

onready var cam_zoom_node = get_node_or_null("../../../GUI/ZoomVScrollBar")

func _on_ZoomScrollBar_value_changed(value):
	zoom = Vector2(value, value)

func _on_camera_panning(relative):
	position -= relative * zoom

func _on_focus_camera(point: Vector2):
	position = point

func _on_camera_zooming(zoom_change, mouse_position):
	zoom = zoom * zoom_change
	var delta_x = (mouse_position.x - global_position.x) * (zoom_change - 1)
	var delta_y = (mouse_position.y - global_position.y) * (zoom_change - 1)
	global_position.x = global_position.x - delta_x
	global_position.y = global_position.y - delta_y
	cam_zoom_node.value = zoom.x
