class_name TurtleAbilities

# symbol -> ability
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

func has_ability(symbol: String) -> bool:
	return _abilities.has(symbol)

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

const potential_user_abilities: Dictionary = {
	"draw_line" : "draw line",
	"shape_1"   : "shape 1",
	"shape_2"   : "shape 2"
}

const potential_control_abilities: Dictionary = {
	"turn_ccw"     : "turn counterclockwise",
	"turn_cw"      : "turn clockwise",
	"open_branch"  : "open branch",
	"close_branch" : "close branch",
}

static func potential_abilities() -> Array:
	return potential_user_abilities.keys() + potential_control_abilities.keys()

static func is_control_ability(ability: String) -> bool:
	return potential_control_abilities.has(ability)

static func is_user_ability(ability: String) -> bool:
	return potential_user_abilities.has(ability)
