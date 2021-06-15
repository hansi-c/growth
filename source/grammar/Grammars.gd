extends Node

func wheat_1l() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["X", # no drawing. only controls the curve
#										 "F", # draw forward
#										 "+", # turn left 25 degrees
#										 "-", # turn right 25 degrees
#										 "[", # push position and angle
#										 "]"] # pop position and angle
	result.axiom = "X"
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+XB", "", "", 1.0))
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+X", "", "", 10.0))
	result.add_production(Production.new("F", "FF", "", "", 10.0))
	return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_7:_Fractal_plant
func wheat_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["X", # no drawing. only controls the curve
#										 "F", # draw forward
#										 "+", # turn left 25 degrees
#										 "-", # turn right 25 degrees
#										 "[", # push position and angle
#										 "]"] # pop position and angle
	result.axiom = "X"
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+XB"))
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+X"))
	result.add_production(Production.new("F", "FF"))
	return result

# taken from https://natureofcode.com/book/chapter-8-fractals/
func ugly_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["F", # draw forward
#										 "+", # turn left 25 degrees
#										 "-", # turn right 25 degrees
#										 "[", # push position and angle
#										 "]"] # pop position and angle
	result.axiom = "F"
	result.add_production(Production.new("F", "FF+[+F-F-F]-[-F+F+F]"))
	return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
func binary_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["0", "1", "[", "]"]
	result.axiom = "0"
	result.add_production(Production.new("1", "11"))
	result.add_production(Production.new("0", "1[0]0"))
	return result

func symmetric_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["X",
#										 "F",
#										 "+",
#										 "-",
#										 "[",
#										 "]"]
	result.axiom = "X"
	result.add_production(Production.new("X", "F[-X][+X]F"))
	result.add_production(Production.new("F", "XF"))
	return result

func snowflake_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["X",
#										 "F",
#										 "+",
#										 "-",
#										 "[",
#										 "]"]
	result.axiom = "X"
	result.add_production(Production.new("X", "F[-X]F[+X]F"))
	result.add_production(Production.new("F", "X"))
	return result

func some_random_grammar() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["A",
#										 "B",
#										 "F",
#										 "+",
#										 "-",
#										 "[",
#										 "]"]
	result.axiom = "ABB"
	result.add_production(Production.new("A", "AFB"))
	result.add_production(Production.new("B", "A[-B][+B]F"))
	return result


#rules  : (F → F−G+F+G−F), (G → GG)
func sierpinski_triangle() -> ILGrammar:
	var result = ILGrammar.new()
#	result.alphabet = ["G",
#										 "F",
#										 "+",
#										 "-",
#										 "[",
#										 "]"]
	result.axiom = "F−G−G"
	result.add_production(Production.new("F", "F−G+F+G−F"))
	result.add_production(Production.new("G", "GG"))
	return result
