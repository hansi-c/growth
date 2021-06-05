extends Node

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

# taken from https://en.wikipedia.org/wiki/L-system#Example_7:_Fractal_plant
func wheat_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["X", # no drawing. only controls the curve
										 "F", # draw forward
										 "+", # turn left 25 degrees
										 "-", # turn right 25 degrees
										 "[", # push position and angle
										 "]"] # pop position and angle
	result.axiom = "X"
	result.productions = {
		"X" : [Production.new("F+[[X]-X]-F[-FX]+X")],
		"F" : [Production.new("FF")]
	}
	return result

# taken from https://natureofcode.com/book/chapter-8-fractals/
func ugly_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["F", # draw forward
										 "+", # turn left 25 degrees
										 "-", # turn right 25 degrees
										 "[", # push position and angle
										 "]"] # pop position and angle
	result.axiom = "F"
	result.productions = {
		"F" : [Production.new("FF+[+F-F-F]-[-F+F+F]")]
	}
	return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
func binary_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["0", "1", "[", "]"]
	result.axiom = "0"
	result.productions = {
		"1" : [Production.new("11")],
		"0" : [Production.new("1[0]0")]
	}
	return result

func symmetric_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.productions = {
		"X" : [Production.new("F[-X][+X]F")],
		"F" : [Production.new("XF")],
	}
	return result

func snowflake_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["X",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "X"
	result.productions = {
		"X" : [Production.new("F[-X]F[+X]F")],
		"F" : [Production.new("X")],
	}
	return result

func some_random_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.alphabet = ["A",
										 "B",
										 "F",
										 "+",
										 "-",
										 "[",
										 "]"]
	result.axiom = "ABB"
	result.rules = {
		"A" : [Production.new("AFB")],
		"B" : [Production.new("A[-B][+B]F")],
	}
	return result
