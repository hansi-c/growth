# Can be a deterministic 0L, 1L or 2L grammar. 0L has no context, 1L has either
# left or right context, 2L has both.
class_name ILGrammar

var alphabet = []
var axiom
var productions = {}
var context_symbols = {}
var production_picker = StochasticProductionPicker.new()

#func add_production2(symbol, successor, left_context="", right_context=""):
#	if not productions.has(symbol):
#		productions[symbol] = []
#	var successors = productions[symbol]
#	successors.append(Production.new(symbol, successor, left_context, right_context))

func add_production(p: Production):
	var symbol = p.predecessor
	if not productions.has(symbol):
		productions[symbol] = []
	var successors = productions[symbol]
	successors.append(p)

func apply_productions(word):
	var result = ""
	for i in range(word.length()):
		var ps = applicable_productions(word, i)
		if not ps.empty():
			var random_index = production_picker.pick_random_weighted(ps)
			result += ps[random_index].successor
		else:
			result += word[i]
	return result

# Returns the index of the next predecessor of a production,
# starting at offset.
# Returns -1 if no production is found until the end of the word.
func find_next_rule(word, offset) -> int:
	var i = offset
	while i < word.length():
		var symbol = word[i]
		if productions.has(symbol):
			return i
		i += 1
	return -1

func apply_production(word, index, applied_production=[]) -> String:
	var result = ""
	var ps = applicable_productions(word, index)
	if ps.empty():
		push_error("unknown rule at index %s in word '%s'" % [index, word])
	else:
		var random_index = production_picker.pick_random_weighted(ps)
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

class AppliedProduction:
	var word: String
	var next_index: int
	var production: Production

func apply_next_production(word:String, index:int,
		applied_production:AppliedProduction) -> bool:
	for i in range(index, word.length()):
		var symbol = word[i]
		if productions.has(symbol):
			var ps = applicable_productions(word, i)
			if not ps.empty():
				var random_index = production_picker.pick_random_weighted(ps)
				var p = ps[random_index]
				applied_production.production = p
				applied_production.word = word.substr(0, index) + p.successor
				if word.length() > index:
					applied_production.word += word.substr(index+1)
				applied_production.next_index = i + p.successor.length()
				return true
	return false

class StochasticProductionPicker:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()

	# Returns an index into the array. The probability for each index is based
	# on the probability factor of the element.
	func pick_random_weighted(applicable_productions: Array) -> int:
		if applicable_productions.size() == 1:
			return 0
		var sum = sum(applicable_productions)
		if sum == 0.0:
			return 0
		var probabilities = weighted(applicable_productions, sum)
		probabilities.sort_custom(self, "sort_ascending")
		return get_random_weighted_index(probabilities)

	static func sum(applicable_productions: Array) -> float:
		var sum = 0.0
		for p in applicable_productions:
			sum += p.probability_factor
		return sum

	static func sort_ascending(a, b) -> bool:
		return a[1] <= b[1]

	static func weighted(applicable_productions, sum):
		var probabilities = []
		for i in range(applicable_productions.size()):
			var factor = applicable_productions[i].probability_factor
			if factor >= 0.0:
				probabilities.append([i, factor/sum])
		return probabilities

	func get_random_weighted_index(probabilities):
		var accumulated_probability = 0.0
		var random = rng.randf()
		for p in probabilities:
			accumulated_probability += p[1]
			if random <= accumulated_probability:
				return p[0]
		return 0
