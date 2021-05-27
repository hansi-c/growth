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

