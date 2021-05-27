extends Node

class Grammar:
	var variables = []
	var constants = []
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

	# applies rule at given index. the rest of the word remains intact.
	# e.g: word = 1[0]0, index = 0, rule = 1 -> 11 returns 11[0]0
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

# taken from https://en.wikipedia.org/wiki/L-system#Example_7:_Fractal_plant
func wheat_grammar() -> Grammar:
	var result = Grammar.new()
	result.variables = ["X", # no drawing. only controls the curve
											"F"] # draw forward
	result.constants = ["+", # turn left 25 degrees
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
	result.variables = ["F"] # draw forward
	result.constants = ["+", # turn left 25 degrees
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
	result.variables = ["0", "1"]
	result.constants = ["[", "]"]
	result.axiom = "0"
	result.rules = {
		"1" : "11",
		"0" : "1[0]0"
	}
	return result

func tomato_grammar() -> Grammar:
	var result = Grammar.new()
	result.variables = ["X", # no drawing. only controls the curve
											"F"] # draw forward
	result.constants = ["+", # turn left 25 degrees
											"-", # turn right 25 degrees
											"[", # push position and angle
											"]"] # pop position and angle
	result.axiom = "X"
	result.rules = {
		"X" : "F[-X]+X",
		"F" : "FF"
	}
	return result
