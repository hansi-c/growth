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

extends OptionButton

var presets = []

signal preset_selected(preset)

func _ready():
	add_presets()
	emit_signal("preset_selected", presets[0])

func add_presets():
	if Globals.grammar:
		add_custom_preset()
	var identity = Preset.new()
	identity.grammar = Grammars.identity_grammar()
	identity.turtle_settings = TurtleSettings.new()
	identity.turtle_abilities = Turtles.default_abilities(identity.grammar)
	var wheat = Preset.new()
	wheat.grammar = Grammars.wheat_1l()
	wheat.turtle_settings = Turtles.wheat_settings()
	wheat.turtle_abilities = Turtles.wheat_abilities(wheat.grammar)
	var sierpinski_60 = Preset.new()
	sierpinski_60.grammar = Grammars.sierpinski_60()
	sierpinski_60.turtle_settings = Turtles.sierpinski_60_settings()
	sierpinski_60.turtle_abilities = Turtles.sierpinski_abilities(sierpinski_60.grammar)
	var sierpinski_120 = Preset.new()
	sierpinski_120.grammar = Grammars.sierpinski_120()
	sierpinski_120.turtle_settings = Turtles.sierpinski_120_settings()
	sierpinski_120.turtle_abilities = Turtles.sierpinski_abilities(sierpinski_120.grammar)
	var koch_snowflake = Preset.new()
	koch_snowflake.grammar = Grammars.koch_snowflake()
	koch_snowflake.turtle_settings = Turtles.koch_curve_settings()
	koch_snowflake.turtle_abilities = Turtles.koch_curve_abilities(koch_snowflake.grammar)
	add_preset("Plant", wheat)
	add_preset("Identity", identity)
	add_preset("Sierpinski 60", sierpinski_60)
	add_preset("Sierpinski 120", sierpinski_120)
	add_preset("Koch snowflake", koch_snowflake)

func add_custom_preset():
	var preset = Preset.new()
	preset.grammar = Globals.grammar
	if Globals.turtle_settings:
		preset.turtle_settings = Globals.turtle_settings
	else:
		preset.turtle_settings = TurtleSettings.new()
	if Globals.turtle_abilities:
		preset.turtle_abilities = Globals.turtle_abilities
	else:
		preset.turtle_abilities = Turtles.default_abilities(Globals.grammar)
	add_preset("Custom", preset)

func add_preset(name: String, preset: Preset):
	presets.append(preset)
	add_item(name)

func _on_item_selected(index):
	emit_signal("preset_selected", presets[index])
