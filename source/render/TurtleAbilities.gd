class_name TurtleAbilities

var _abilities = {}

func add_ability(symbol: String, ability: String):
	_abilities[symbol] = ability
	
func remove_symbol(symbol: String):
	_abilities.erase(symbol)

func has_symbol(symbol: String):
	return _abilities.has(symbol)

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
