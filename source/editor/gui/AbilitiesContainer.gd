extends GridContainer

var _ability_group_prefix = "_ability_"

signal ability_removed(symbol)

func _on_add_ability(symbol: String):
	var ability_group = _concat_ability_group(symbol)
	add_ability_button(symbol, ability_group)
	add_ability_options(ability_group)

func _concat_ability_group(symbol):
	return _ability_group_prefix + symbol

func add_ability_button(symbol: String, ability_group: String):
	var ability_button = Button.new()
	ability_button.add_to_group(ability_group)
	ability_button.set_text(symbol)
	ability_button.connect("button_up", self, "_on_ability_button_up", [ability_group])
	add_child(ability_button)
	
func add_ability_options(ability_group: String):
	var ability_option = OptionButton.new()
	ability_option.add_to_group(ability_group)
	ability_option.add_item("ability 1")
	ability_option.add_item("ability 2")
	ability_option.add_item("ability 3")
	add_child(ability_option)
	
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
