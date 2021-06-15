# Can be a deterministic 0L, 1L or 2L grammar. 0L has no context, 1L has either
# left or right context, 2L has both.
class_name ILGrammar

var alphabet = []
var axiom
var productions = {}
var context_symbols = {}
var production_picker: ProductionPicker = ProductionPicker.new()

func set_production_picker(_production_picker:ProductionPicker):
	production_picker = _production_picker

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
				var random_index = production_picker.pick(ps)
				var p = ps[random_index]
				applied_production.production = p
				applied_production.word = word.substr(0, index) + p.successor
				if word.length() > index:
					applied_production.word += word.substr(index+1)
				applied_production.next_index = i + p.successor.length()
				return true
	return false
	
