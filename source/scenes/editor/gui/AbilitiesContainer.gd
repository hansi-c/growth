extends GridContainer

const _ability_group_prefix = "_ability_"
var turtle_abilities: TurtleAbilities

signal ability_added(symbol)
signal ability_removed(symbol)

func _ready():
	if Globals.turtle_abilities == null:
		Globals.turtle_abilities = Turtles.default_abilities(Globals.grammar.alphabet())
	turtle_abilities = Turtles.duplicate_abilities(Globals.turtle_abilities)
	if not Globals.turtle_potential_abilities or Globals.turtle_potential_abilities.empty():
		Globals.turtle_potential_abilities = Turtle.new().enumerate_potential_abilities()
	_initialize_active_abilities()

func _initialize_active_abilities():
	for pair in turtle_abilities.enumerate_abilities():
		var symbol = pair[0]
		_on_add_ability(symbol)

func _on_add_ability(symbol: String):
	var ability_group = _concat_ability_group(symbol)
	add_ability_button(symbol, ability_group)
	add_ability_options(symbol, ability_group)
	emit_signal("ability_added", symbol)

func _concat_ability_group(symbol):
	return _ability_group_prefix + symbol

func add_ability_button(symbol: String, ability_group: String):
	var ability_button = Button.new()
	ability_button.add_to_group(ability_group)
	ability_button.set_text(symbol)
	ability_button.connect("button_up", self, "_on_ability_button_up", [ability_group])
	add_child(ability_button)
	
func add_ability_options(symbol: String, ability_group: String):
	var ability_option = OptionButton.new()
	ability_option.add_to_group(ability_group)
	var active_ability = turtle_abilities.get_ability(symbol)
	for i in range(Globals.turtle_potential_abilities.size()):
		var a = Globals.turtle_potential_abilities[i]
		ability_option.add_item(a)
		if a == active_ability:
			ability_option.select(i)
	add_child(ability_option)
	turtle_abilities.set_ability(symbol, Globals.turtle_potential_abilities[ability_option.selected])
	ability_option.connect("item_selected", self, "_on_ability_selected", [ability_group])

func _on_ability_selected(index: int, ability_group: String):
	var ability_symbol = _extract_ability_from_group(ability_group)
	var ability = Globals.turtle_potential_abilities[index]
	turtle_abilities.set_ability(ability_symbol, ability)
#	print("%s : %s" % [ability_symbol, ability])
	
func _on_ability_button_up(ability_group: String):
	_remove_ability(ability_group)
	var ability_symbol = _extract_ability_from_group(ability_group)
	emit_signal("ability_removed", ability_symbol)

func _remove_ability(ability_group: String):
	var nodes = get_tree().get_nodes_in_group(ability_group)
	for node in nodes:
		node.queue_free()
	var symbol = _extract_ability_from_group(ability_group)
	turtle_abilities.remove_symbol(symbol)

func _extract_ability_from_group(ability_group: String) -> String:
	if ability_group.begins_with(_ability_group_prefix):
		return ability_group[ability_group.length()-1]
	else:
		push_error("invalid ability group: %s" % ability_group)
		return ""

func _on_alphabet_changed(grammar: ILGrammar):
	var alphabet = grammar.alphabet()
	for child in get_children():
		if child is Button:
			var symbol = child.get_text()
			if not alphabet.has(symbol):
				var ability_group = _concat_ability_group(symbol)
				_remove_ability(ability_group)

func _on_BackButton_button_up():
	Globals.turtle_abilities = turtle_abilities
