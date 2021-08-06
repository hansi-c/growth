class_name TurtleAbilities

const potential_user_abilities: Dictionary = {
	"draw_line" : true,
	"shape_1"   : true,
	"shape_2"   : true
}
const potential_control_abilities: Dictionary = {
	"turn_ccw"     : true,
	"turn_cw"      : true,
	"open_branch"  : true,
	"close_branch" : true,
}
var _abilities: Dictionary = {}

func add_abilities(abilities: Dictionary):
	for key in abilities.keys():
		add_ability(key, abilities[key])

func add_ability(symbol: String, ability: String):
	_abilities[symbol] = ability

func remove_symbol(symbol: String):
	_abilities.erase(symbol)

func has_symbol(symbol: String) -> bool:
	return _abilities.has(symbol)

func get_ability(symbol: String) -> String:
	return _abilities[symbol]

func is_control_ability(ability: String) -> bool:
	return potential_control_abilities.has(ability)

func is_user_ability(ability: String) -> bool:
	return potential_user_abilities.has(ability)

# returns an array of arrays.
# the inner arrays have 2 entries: [symbol, ability]
func enumerate_abilities() -> Array:
	var result = []
	for key in _abilities:
		var pair = [key, _abilities[key]]
		result.append(pair)
	return result

func clear():
	_abilities.clear()

func _to_string() -> String:
	return str(enumerate_abilities())

static func potential_abilities() -> Array:
	return potential_user_abilities.keys() + potential_control_abilities.keys()
