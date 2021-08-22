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

# AbilitiesContainer.gd
extends Container

const _ability_group_prefix = "_ability_"
var _user_ability_container
var _control_ability_container

const _potential_user_abilities: Dictionary = {
	TurtleAbilities.DRAW_LINE : "draw line",
	TurtleAbilities.SHAPE_1   : "shape 1",
	TurtleAbilities.SHAPE_2   : "shape 2"
}

const _potential_control_abilities: Dictionary = {
	TurtleAbilities.OPEN_BRANCH  : "open branch",
	TurtleAbilities.CLOSE_BRANCH : "close branch",
	TurtleAbilities.TURN_CCW     : "turn counterclockwise",
	TurtleAbilities.TURN_CW      : "turn clockwise",
}

func _ready():
	if Globals.turtle_abilities == null:
		Globals.turtle_abilities = Turtles.default_abilities(Globals.grammar)
	_initialize_user_ability_container()
	_initialize_control_ability_container()
	_add_new_user_ability_rows(Globals.grammar)
	_select_inital_user_abilities()
	
func _select_inital_user_abilities():
	var turtle_abilities: TurtleAbilities = Globals.turtle_abilities
	for entry in turtle_abilities.enumerate_abilities():
		var symbol: String = entry[0]
		var ability: String = entry[1]
		var user_elements = _user_ability_container.get_children()
		var i = 0
		while i < user_elements.size():
			var child = user_elements[i]
			if child is Label and child.get_text() == symbol:
				var option_button: OptionButton = user_elements[i+1]
				var item_found = false
				for j in range (option_button.get_item_count()):
					var item_text = option_button.get_item_text(j)
					if _potential_user_abilities[ability] == item_text:
						option_button.select(j)
						item_found = true
				if item_found:
					break
			else:
				i += 1
			i += 1

func _initialize_user_ability_container():
	if _user_ability_container == null:
		_user_ability_container = get_node_or_null("UserAbilitiesContainer")

func _initialize_control_ability_container():
	if _control_ability_container == null:
		_control_ability_container = get_node_or_null("ControlAbilitiesContainer")

func _concat_ability_group(symbol):
	return _ability_group_prefix + symbol

func _remove_ability(ability_group: String):
	var nodes = get_tree().get_nodes_in_group(ability_group)
	for node in nodes:
		node.queue_free()

func _on_alphabet_changed(grammar: ILGrammar):
	_initialize_user_ability_container()
	_remove_deleted_user_abilities(grammar)
	_add_new_user_ability_rows(grammar)
	if _control_ability_container == null:
		_initialize_control_ability_rows(grammar)

func _remove_deleted_user_abilities(grammar: ILGrammar):
	var alphabet: Dictionary = grammar.alphabet()
	for child in _user_ability_container.get_children():
		if child is Label:
			var symbol: String = child.get_text()
			if not alphabet.has(symbol):
				var ability_group: String = _concat_ability_group(symbol)
				_remove_ability(ability_group)

func _add_new_user_ability_rows(grammar: ILGrammar):
	var alphabet: Dictionary = grammar.alphabet()
	for symbol in alphabet:
		if grammar.is_control_symbol(symbol):
			continue
		var has_symbol = false
		for child in _user_ability_container.get_children():
			if child is Label:
				var label_text: String = child.get_text()
				if label_text == symbol:
					has_symbol = true
					break
		if not has_symbol:
			_add_user_ability_row(symbol)
			
func _add_user_ability_row(symbol: String):
	var label = Label.new()
	label.set_text(symbol)
	var dropdown: OptionButton = OptionButton.new()
	dropdown.set_custom_minimum_size(Vector2(100.0, 0.0))
	dropdown.add_item("")
	for i in range(_potential_user_abilities.size()):
		var ability = _potential_user_abilities.keys()[i]
		var description: String = _potential_user_abilities[ability]
		dropdown.add_item(description)
	_user_ability_container.add_child(label)
	_user_ability_container.add_child(dropdown)
	var ability_group = _concat_ability_group(symbol)
	label.add_to_group(ability_group)
	dropdown.add_to_group(ability_group)

func _initialize_control_ability_rows(grammar: ILGrammar):
	_initialize_control_ability_container()
	var control_symbols: ControlSymbols = grammar.control_symbols
	for control_ability in control_symbols.enumerate_dictionary():
		var control_symbol = control_symbols.get_symbol(control_ability)
		var symbol_label = Label.new()
		symbol_label.set_text(control_symbol)
		var ability_label = Label.new()
		ability_label.set_text(control_ability)
		_control_ability_container.add_child(symbol_label)
		_control_ability_container.add_child(ability_label)

func _on_BackButton_button_up():
	Globals.turtle_abilities = TurtleAbilities.new()
	# FIXME this relies very much on the gui layout
	var symbol = ""
	for child in _user_ability_container.get_children():
		if child is Label:
			symbol = child.get_text()
		elif child is OptionButton:
			var selected_index = child.get_selected()
			var ability_description = child.get_item_text(selected_index)
			for ability in _potential_user_abilities:
				if _potential_user_abilities[ability] == ability_description:
					Globals.turtle_abilities.add_ability(symbol, ability)
					break
	Turtles.add_control_abilities(Globals.turtle_abilities,
			Globals.grammar.control_symbols)
