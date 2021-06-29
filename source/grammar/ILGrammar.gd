# Can be a 0L, 1L or 2L grammar. 0L has no context, 1L has either
# left or right context, 2L has both. The grammar will be deterministic
# or non-deterministic according to its production picker.
class_name ILGrammar

var axiom
var productions = {}
#var context_symbols = {}
var production_picker: ProductionPicker = ProductionPicker.new()

func set_production_picker(_production_picker:ProductionPicker):
	production_picker = _production_picker

func add_production(p: Production):
	var symbol = p.predecessor
	if not productions.has(symbol):
		productions[symbol] = []
	var successors = productions[symbol]
	successors.append(p)

func delete_production(production: Production):
	for s in productions:
		productions[s].erase(production)
		if productions[s].empty():
			productions.erase(s)

# this needs to be called because the production's predecessor is used
# as a key into the productions dictionary
func update_predecessor(production: Production):
	delete_production(production)
	add_production(production)
	
func apply_productions(word):
	var result = ""
	for i in range(word.length()):
		var ps = applicable_productions(word, i)
		if not ps.empty():
			var random_index = production_picker.pick(ps)
			result += ps[random_index].successor
		else:
			result += word[i]
	return result

# Returns the index of the next predecessor of a production,
# starting at offset.
# Returns an index > word.length() if no production is found until the end of the word.
func find_next_rule(word, offset) -> int:
	var i = offset
	while i < word.length():
		var symbol = word[i]
		if productions.has(symbol):
			break
		i += 1
	return i

func apply_production(word, index, applied_production=[]) -> String:
	var result = ""
	var ps = applicable_productions(word, index)
	if ps.empty():
		push_error("unknown rule at index %s in word '%s'" % [index, word])
	else:
		var random_index = production_picker.pick(ps)
		var p = ps[random_index]
		if applied_production.size() > 0:
			applied_production[0] = p
		result = word.substr(0, index) + p.successor
		if word.length() > index:
			result += word.substr(index+1)
	return result

func applicable_productions(word, index):
	var s = word[index]
	var result = []
	if productions.has(s):
		var successors = productions[s]
		for p in successors:
			if p.matches_context(word, index):
				result.append(p)
	return result

# w : ABC
# p1 : A < B -> A  : 1
# p2 : B > C -> BB : 2
func _to_string() -> String:
	var result = ""
	result += "alphabet: %s" % str(alphabet())
	result += "\naxiom: " + axiom
	for s in productions:
		for p in productions[s]:
			result += "\n" + p._to_string()
	return result

func production_count():
	var count = 0
	for s in productions:
		for p in productions[s]:
			count += 1
	return count
	
func alphabet() -> Array:
	var result = {}
	if axiom and not axiom.empty():
		_add_unique_chars(result, axiom)
	for s in productions:
		for p in productions[s]:
			_add_unique_chars(result, p.left_context)
			_add_unique_chars(result, p.predecessor)
			_add_unique_chars(result, p.successor)
	return result.keys()

func _add_unique_chars(target: Dictionary, source: String):
	if source and not source.empty():
		for c in source:
			target[c] = true
