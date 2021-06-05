class_name Production

var successor: String
var left_context: String
var right_context: String
#	var relevant_symbols: Dictionary # this can be used to determine a context ignoring special symbols like '+' and so on
var probability_factor: float = 0.0

func _init(_successor, _left_context="", _right_context="", _probability=0.0):
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
