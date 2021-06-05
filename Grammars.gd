extends Node

# Deterministic, context-free grammar. Produces D0L-Systems.
class Grammar:
	var alphabet = []
	var axiom
	var rules = {}

	func apply_rules(word):
		var result = ""
		for s in word:
			if rules.has(s):
				result += rules[s]
			else:
				result += s
		return result

	# applies rule at given index. the rest of the word remains the same.
	# e.g: word = BAA, index = 1, rule = A -> B returns BBA
	func apply_rule(word, index) -> String:
		var result = ""
		var rule = word[index]
		if rules.has(rule):
			result = word.substr(0, index) + rules[rule]
			if word.length() > index:
				result += word.substr(index+1)
		else:
			push_error("unknown rule at index %s in word '%s'" % [index, word])
		return result

class Production:
	var successor: String
	var left_context: String
	var right_context: String
#	var relevant_symbols: Dictionary # this can be used to determine a context ignoring special symbols like '+' and so on
	var probability_factor: float = 0.0

	func _init(_successor, _left_context, _right_context, _probability=0.0):
		successor = _successor
		left_context = _left_context
		right_context = _right_context
		probability_factor = _probability

	func matches_context(word, index) -> bool:
		return matches_left_context(word, index) and matches_right_context(word, index)

	# implemented pseudo code from http://algorithmicbotany.org/papers/hanan.dis1992.pdf
	# PARAMETRIC L-SYSTEMS AND THEIR APPLICATION TO THE MODELLING AND VISUALIZATION OF PLANTS
	# by James Scott Hanan, 1992, page 24
	func matches_left_context(word, index) -> bool:
		if left_context == null:
			return true
		elif not left_context.empty() and index == 0:
			return false

		var i = index - 1
		var j = left_context.length() - 1
		var matches = true

		while matches and i >= 0 and j >= 0:
			# skip substrings representing branches
			if word[i] == "]":
				# move the index i to point at the first character to the left of the
				# matching left bracket
				i = skip_matching_left_bracket(word, i)
			elif word[i] == "[":
				# skip left brackets
				i -= 1
			else:
				# nothing to be skipped, check for match
				if word[i] == left_context[j]:
					i -= 1
					j -= 1
				else:
					# mismatch
					matches = false

			if i < 0 and j >= 0:
				# the string index is past the left end and there is still context to match
				matches = false

		return matches

	func skip_matching_left_bracket(word, i) -> int:
		var count = 1
		while i > 0 and count > 0:
			i -= 1
			if word[i] == "[":
				count -= 1
			elif word[i] == "]":
				count += 1
		return i

	func matches_right_context(word, index) -> bool:
		if right_context == null or right_context.empty():
			return true
		return false

# Can be a deterministic 0L, 1L or 2L grammar. 0L has no context, 1L has either
# left or right context, 2L has both.
class ILGrammar:
	var alphabet = []
	var axiom
	var productions = {}
	var context_symbols = {}
	var production_picker = StochasticProductionPicker.new()
	var last_applied_production

	func add_production(symbol, successor, left_context=null, right_context=null):
		if not productions.has(symbol):
			productions[symbol] = []
		var successors = productions[symbol]
		successors.append(Production.new(successor, left_context, right_context))

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

	func apply_production(word, index):
		var result = ""
		var ps = applicable_productions(word, index)
		if ps.empty():
			push_error("unknown rule at index %s in word '%s'" % [index, word])
		else:
			var random_index = production_picker.pick_random_weighted(ps)
			var p = ps[random_index]
			last_applied_production = p
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

func wheat_1l() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["X", # no drawing. only controls the curve
										 "F", # draw forward
										 "+", # turn left 25 degrees
										 "-", # turn right 25 degrees
										 "[", # push position and angle
										 "]"] # pop position and angle
	result.axiom = "X"
	result.productions = {
		"X" : [Production.new("F+[[AX]-X]-F[-FX]+XB", "", "", 1.0),
					 Production.new("F+[[AX]-X]-F[-FX]+X", "", "", 10.0)],
		"F" : [Production.new("FF", "", "")]
	}
	return result

# Alternative implementation using a PoolStringArray instead of String.
# I tried benchmarking this vs the String version to find out if we can reach
# higher iterations with less performance loss. Turns out that it does not
# matter whether we use String or Pool array. A word length in the 100,000s will
# always freeze the grammar productions.
class Grammar2:
	var alphabet = []
	var axiom
	var rules = {}

	func apply_rules(word: PoolStringArray):
		var result = PoolStringArray()
		for s in word:
			var p
			if rules.has(s):
				p = rules[s]
			else:
				p = s
			result.append(p)
		return result

# Another implementation using a normal Array. Same result as with the other
# implementations, ie no difference in performance.
class Grammar3:
	var alphabet = []
	var axiom
	var rules = {}

	func apply_rules(word: Array):
		var result = []
		for s in word:
			var p
			if rules.has(s):
				p = rules[s]
			else:
				p = s
			result.append(p)
		return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_7:_Fractal_plant
func wheat_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["X", # no drawing. only controls the curve
										 "F", # draw forward
										 "+", # turn left 25 degrees
										 "-", # turn right 25 degrees
										 "[", # push position and angle
										 "]"] # pop position and angle
	result.axiom = "X"
	result.rules = {
		"X" : "F+[[X]-X]-F[-FX]+X",
		"F" : "FF"
	}
	return result

# taken from https://natureofcode.com/book/chapter-8-fractals/
func ugly_tree_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["F", # draw forward
										 "+", # turn left 25 degrees
										 "-", # turn right 25 degrees
										 "[", # push position and angle
										 "]"] # pop position and angle
	result.axiom = "F"
	result.rules = {
		"F" : "FF+[+F-F-F]-[-F+F+F]"
	}
	return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
func binary_tree_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["0", "1", "[", "]"]
	result.axiom = "0"
	result.rules = {
		"1" : "11",
		"0" : "1[0]0"
	}
	return result

func symmetric_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.rules = {
		"X" : "F[-X][+X]F",
		"F" : "XF",
	}
	return result

func snowflake_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.rules = {
		"X" : "F[-X]F[+X]F",
		"F" : "X",
	}
	return result

func snowflake_grammar2() -> Grammar2:
	var result = Grammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.rules = {
		"X" : "F[-X]F[+X]F",
		"F" : "X",
	}
	return result

func snowflake_grammar3() -> Grammar3:
	var result = Grammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.rules = {
		"X" : "F[-X]F[+X]F",
		"F" : "X",
	}
	return result

func some_random_grammar() -> Grammar:
	var result = Grammar.new()
	result.alphabet = ["A",
										 "B",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "ABB"
	result.rules = {
		"A" : "AFB",
		"B" : "A[-B][+B]F",
	}
	return result

