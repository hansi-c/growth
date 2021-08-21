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

class_name Production

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

func matches_context(word: String, index: int, context_symbols=null, branching_symbols: BranchingSymbols=BranchingSymbols.new()) -> bool:
	return matches_left_context(word, index, context_symbols, branching_symbols) and matches_right_context(word, index, context_symbols, branching_symbols)

# implemented pseudo code from http://algorithmicbotany.org/papers/hanan.dis1992.pdf
# PARAMETRIC L-SYSTEMS AND THEIR APPLICATION TO THE MODELLING AND VISUALIZATION OF PLANTS
# by James Scott Hanan, 1992, page 24
func matches_left_context(word: String, index: int, context_symbols=null, branching_symbols: BranchingSymbols=BranchingSymbols.new()) -> bool:
	if left_context == null:
		return true
	elif not left_context.empty() and index == 0:
		return false

	var i = index - 1
	var j = left_context.length() - 1
	var matches = true

	while matches and i >= 0 and j >= 0:
		# skip substrings representing branches
		if word[i] == branching_symbols.close_branch:
			# move the index i to point at the first character to the left of the
			# matching left bracket
			i = skip_matching_left_bracket(word, i, branching_symbols)
		elif word[i] == branching_symbols.open_branch:
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
					matches = false
			else:
				i -= 1
		if i < 0 and j >= 0:
			# the string index is past the left end and there is still context to match
			matches = false

	return matches

func skip_matching_left_bracket(word: String, index: int, branching_symbols: BranchingSymbols) -> int:
	var count = 1
	while index > 0 and count > 0:
		index -= 1
		if word[index] == branching_symbols.open_branch:
			count -= 1
		elif word[index] == branching_symbols.close_branch:
			count += 1
	return index

func matches_right_context(_word: String, _index: int, _context_symbols=null, _branching_symbols: BranchingSymbols=BranchingSymbols.new()) -> bool:
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
	
