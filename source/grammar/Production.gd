class_name Production

var open_branch = "["
var close_branch = "]"
var predecessor: String
var successor: String
var left_context: String
var right_context: String
var probability_factor: float = 1.0

func _init(_predecessor, _successor, _left_context="", _right_context="", _probability=1.0):
	predecessor = _predecessor
	successor = _successor
	left_context = _left_context
	right_context = _right_context
	probability_factor = _probability

func matches_context(word: String, index: int, context_symbols=null) -> bool:
	return matches_left_context(word, index, context_symbols) and matches_right_context(word, index, context_symbols)

# implemented pseudo code from http://algorithmicbotany.org/papers/hanan.dis1992.pdf
# PARAMETRIC L-SYSTEMS AND THEIR APPLICATION TO THE MODELLING AND VISUALIZATION OF PLANTS
# by James Scott Hanan, 1992, page 24
func matches_left_context(word: String, index: int, context_symbols=null) -> bool:
	if left_context == null or left_context.empty():
		return true
	elif index == 0:
		return false

	var i = index - 1
	var j = left_context.length() - 1
	var matches = true

	while matches and i >= 0 and j >= 0:
		# skip substrings representing branches
		if word[i] == close_branch:
			# move the index i to point at the first character to the left of the
			# matching left bracket
			i = skip_matching_left_bracket(word, i)
		elif word[i] == open_branch:
			# skip left brackets
			i -= 1
		else:
			# nothing to be skipped, check for match
			var word_symbol = word[i]
			var context_symbol = left_context[j]
			if not context_symbols or context_symbols.has(word_symbol):
				if word_symbol == context_symbol:
					i -= 1
					j -= 1
				else:
					# mismatch
					matches = false
			else:
				i -= 1
		if i < 0 and j >= 0:
			# the string index is past the left end and there is still context to match
			matches = false
	return matches

func skip_matching_left_bracket(word: String, index: int) -> int:
	var count = 1
	while index > 0 and count > 0:
		index -= 1
		if word[index] == open_branch:
			count -= 1
		elif word[index] == close_branch:
			count += 1
	return index

func matches_right_context(_word: String, _index: int, _context_symbols=null) -> bool:
	return true

# w : ABC
# p1 : A < B -> A  : 1
# p2 : B > C -> BB : 2
func _to_string() -> String:
	var result = ""
	if left_context and not left_context.empty():
		result += left_context + " < "
	result += predecessor
	if right_context and not right_context.empty():
		result += " > " + right_context
	result += " -> " + successor
	if probability_factor > 0.0:
		result += " : " + str(probability_factor)
	return result
	
