# growth - Lindenmayer Systems implemented in Godot
# Copyright (C) 2021  Christoph Czurda <rdssdf.fd@gmx.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

extends Node

# returns a deep clone of the grammar's productions.
# the production picker is shared
func duplicate_grammar(grammar: ILGrammar):
	var result = ILGrammar.new()
	result.axiom = grammar.axiom
	for s in grammar.productions:
		for p in grammar.productions[s]:
			result.add_production(duplicate_production(p))
	return result

func duplicate_production(production: Production):
	return Production.new(production.predecessor, production.successor, production.left_context, production.right_context, production.probability_factor)

# taken from https://en.wikipedia.org/wiki/L-system#Example_7:_Fractal_plant
func wheat_1l() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "X"
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+XB", "", "", 1.0))
	result.add_production(Production.new("X", "F+[[AX]-X]-F[-FX]+X", "", "", 10.0))
	result.add_production(Production.new("F", "FF", "", ""))
	return result

# taken from https://natureofcode.com/book/chapter-8-fractals/
func ugly_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "F"
	result.add_production(Production.new("F", "FF+[+F-F-F]-[-F+F+F]"))
	return result

# taken from https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
func binary_tree_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "0"
	result.add_production(Production.new("1", "11"))
	result.add_production(Production.new("0", "1[0]0"))
	return result

func symmetric_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "X"
	result.add_production(Production.new("X", "F[-X][+X]F"))
	result.add_production(Production.new("F", "XF"))
	return result

func snowflake_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "X"
	result.add_production(Production.new("X", "F[-X]F[+X]F"))
	result.add_production(Production.new("F", "X"))
	return result

func some_random_grammar() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "ABB"
	result.add_production(Production.new("A", "AFB"))
	result.add_production(Production.new("B", "A[-B][+B]F"))
	return result

func sierpinski_120() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "F-G-G"
	result.add_production(Production.new("F", "F-G+F+G-F"))
	result.add_production(Production.new("G", "GG"))
	return result

func sierpinski_60() -> ILGrammar:
	var result = ILGrammar.new()
	result.axiom = "F"
	result.add_production(Production.new("F", "G-F-G"))
	result.add_production(Production.new("G", "F+G+F"))
	return result

# returns a grammar with only the identity production.
func identity_grammar(symbol="F") -> ILGrammar:
	var result = ILGrammar.new()
	var identity = Production.new(symbol, symbol)
	result.add_production(identity)
	result.axiom = symbol
	return result
