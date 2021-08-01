# Can be a 0L, 1L or 2L grammar. 0L has no context, 1L has either
# left or right context, 2L has both.
class_name ILGrammar

var axiom: String
# maps from predecessor to an array of applicable productions
var productions = {}
var context_symbols = {}
var control_symbols: ControlSymbols = ControlSymbols.new()

func add_production(p: Production):
	if not productions.has(p.predecessor):
		productions[p.predecessor] = []
	var successors = productions[p.predecessor]
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
	
# Returns the index of the next predecessor of a production,
# starting at offset.
# Returns an index >= word.length() if no production is found until the end of the word.
# The argument _applicable_productions will hold all productions that are possible
# at the returned index.
func find_next_rule(word: String, offset: int, _applicable_productions: Array) -> int:
	for i in range(offset, word.length()):
		var symbol = word[i]
		if productions.has(symbol):
			applicable_productions(word, i, _applicable_productions)
			if not _applicable_productions.empty():
				return i
		i += 1
	return word.length()

func applicable_productions(word: String, index: int, _applicable_productions: Array):
	var s = word[index]
#	var result = []
	if productions.has(s):
		var successors = productions[s]
		for p in successors:
			var branching_symbols = control_symbols.get_branching_symbols()
			if p.matches_context(word, index, context_symbols, branching_symbols):
				_applicable_productions.append(p)
#	return result

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

func production_count() -> int:
	var count = 0
	for s in productions:
		for p in productions[s]:
			count += 1
	return count
	
func alphabet() -> Dictionary:
	var result = {}
	if axiom and not axiom.empty():
		_add_unique_chars(result, axiom)
	for s in productions:
		for p in productions[s]:
			_add_unique_chars(result, p.left_context)
			_add_unique_chars(result, p.predecessor)
			_add_unique_chars(result, p.successor)
	for s in control_symbols.enumerate():
		_add_unique_chars(result, s)
	return result

func alphabet_list() -> Array:
	return alphabet().keys()

func alphabet_sorted() -> Array:
	var keys = alphabet_list()
	keys.sort()
	return keys

func _add_unique_chars(target: Dictionary, source: String):
	if source and not source.empty():
		for c in source:
			target[c] = true
