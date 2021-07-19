class_name TurtleAbilities

var _abilities = {}

func set_ability(symbol: String, ability: String):
	_abilities[symbol] = ability
	
func remove_symbol(symbol: String):
	_abilities.erase(symbol)

func has_symbol(symbol: String):
	return _abilities.has(symbol)

func get_ability(symbol: String):
	if _abilities.has(symbol):
		return _abilities[symbol]
	else:
		return ""

# returns an array of arrays.
# the inner arrays have 2 entries: [symbol, ability]
func enumerate_abilities():
	var result = []
	for key in _abilities:
		var pair = [key, _abilities[key]]
		result.append(pair)
	return result

func clear():
	_abilities.clear()

func _to_string():
	return str(_abilities)
