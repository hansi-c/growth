# AbilitiesContainer.gd
extends Container

const _ability_group_prefix = "_ability_"
var abilities: Dictionary = {}
onready var _user_ability_container = get_node_or_null("UserAbilitiesContainer")
onready var _control_ability_container = get_node_or_null("ControlAbilitiesContainer")
# use this array to have potential abilities in a fixed order
var _potential_user_abilities = TurtleAbilities.potential_user_abilities.keys()

signal ability_added(symbol)
signal ability_removed(symbol)

func _ready():
	if Globals.turtle_abilities == null:
		Globals.turtle_abilities = Turtles.default_abilities(Globals.grammar)
	_initialize_abilities()

func _initialize_abilities():
	for pair in Globals.turtle_abilities.enumerate_abilities():
		var symbol = pair[0]
		var ability = pair[1]
		if TurtleAbilities.is_control_ability(ability):
			_add_control_ability(symbol, ability)
		else:
			_add_user_ability(symbol, ability)

func _add_control_ability(symbol: String, ability: String):
	var symbol_label = Label.new()
	symbol_label.set_text(symbol)
	var description = TurtleAbilities.potential_control_abilities[ability]
	var ability_label = Label.new()
	ability_label.set_text(description)
	_control_ability_container.add_child(symbol_label)
	_control_ability_container.add_child(ability_label)
	
func _on_add_ability(symbol: String):
	_add_user_ability(symbol, _potential_user_abilities[0])

func _add_user_ability(symbol: String, initial_ability: String):
	var ability_group = _concat_ability_group(symbol)
	_add_ability_button(symbol, ability_group)
	_add_ability_options(initial_ability, ability_group)
	emit_signal("ability_added", symbol)

func _concat_ability_group(symbol):
	return _ability_group_prefix + symbol

func _add_ability_button(symbol: String, ability_group: String):
	var ability_button = Button.new()
	ability_button.add_to_group(ability_group)
	ability_button.set_text(symbol)
	ability_button.connect("button_up", self, "_on_ability_button_up", [ability_group])
	_user_ability_container.add_child(ability_button)
	
func _add_ability_options(initial_ability: String, ability_group: String):
	var ability_options = OptionButton.new()
	ability_options.add_to_group(ability_group)
	_populate_user_ability_options(ability_options, initial_ability)
	_user_ability_container.add_child(ability_options)

func _populate_user_ability_options(options: OptionButton, initial_ability: String):
	# we use an array to give abilities constant ids
	# if no id argument is passed to OptionButton::add_item(),
	# ids default to insertion order
	# IOW, the ids correspond to _potential_user_abilities indices
	for i in range(_potential_user_abilities.size()):
		var ability = _potential_user_abilities[i]
		var description = TurtleAbilities.potential_user_abilities[ability]
		options.add_item(description)
		if ability == initial_ability:
			options.select(i)

func _on_ability_button_up(ability_group: String):
	_remove_ability(ability_group)
	var ability_symbol = _extract_ability_from_group(ability_group)
	emit_signal("ability_removed", ability_symbol)

func _remove_ability(ability_group: String):
	var nodes = get_tree().get_nodes_in_group(ability_group)
	for node in nodes:
		node.queue_free()

func _extract_ability_from_group(ability_group: String) -> String:
	if ability_group.begins_with(_ability_group_prefix):
		return ability_group[ability_group.length()-1]
	else:
		push_error("invalid ability group: %s" % ability_group)
		return ""

func _on_alphabet_changed(grammar: ILGrammar):
	if _user_ability_container == null:
		return
	var alphabet = grammar.alphabet()
	for child in _user_ability_container.get_children():
		if child is Button:
			var symbol = child.get_text()
			if not alphabet.has(symbol):
				var ability_group = _concat_ability_group(symbol)
				_remove_ability(ability_group)

func _on_BackButton_button_up():
	Globals.turtle_abilities = TurtleAbilities.new()
	# FIXME this relies too much on the gui layout
	var symbol = ""
	for child in _user_ability_container.get_children():
		if child is Button and not child is OptionButton:
			symbol = child.get_text()
		elif child is OptionButton:
			var id = child.get_selected_id()
			var ability = _potential_user_abilities[id]
			Globals.turtle_abilities.add_ability(symbol, ability)
	Turtles.add_control_abilities(Globals.turtle_abilities,
			Globals.grammar.control_symbols)
