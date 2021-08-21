class_name ControlSymbols

var _dictionary = {
	TurtleAbilities.TURN_CW      : "-",
	TurtleAbilities.TURN_CCW     : "+",
	TurtleAbilities.OPEN_BRANCH  : "[",
	TurtleAbilities.CLOSE_BRANCH : "]"
}

func has_ability(ability: String) -> bool:
	return _dictionary.has(ability)

func get_symbol(ability: String):
	return _dictionary[ability]

func set_symbol(ability: String, symbol: String):
	_dictionary[ability] = symbol

func get_branching_symbols() -> BranchingSymbols:
	return BranchingSymbols.new(_dictionary[TurtleAbilities.OPEN_BRANCH],
	 _dictionary[TurtleAbilities.CLOSE_BRANCH])

func enumerate() -> Array:
	return _dictionary.values()
#
func enumerate_dictionary() -> Dictionary:
	return _dictionary.duplicate()
	
func _to_string() -> String:
	return ""
