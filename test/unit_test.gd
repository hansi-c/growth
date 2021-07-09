extends Node

func _ready():
	test_apply_rule()
	test_match_left_context()
	test_context_symbols()

func test_apply_rule():
	var grammar = ILGrammar.new()
	grammar.add_production(Production.new("0", "Zero"))
	grammar.add_production(Production.new("1", "One"))
	grammar.add_production(Production.new("2", "Two"))

	var word = "0"
	var result = grammar.apply_production(word, 0)
	print(result)
	assert(result == "Zero")

	word = "012"
	result = grammar.apply_production(word, 0)
	print(result)
	assert(result == "Zero12")
	result = grammar.apply_production(word, 1)
	print(result)
	assert(result == "0One2")
	result = grammar.apply_production(word, 2)
	print(result)
	assert(result == "01Two")

	word = "+"
	result = grammar.apply_production(word, 0)
	print(result)
	assert(result == word)

func test_match_left_context():
	var production = Production.new("","", "ABC", "")
	var word = "ABC[DE][FG[HI[JK]L]MNO]P"
	var index = 8 # F
	var matches = production.matches_left_context(word, index)
	assert(matches == true)

	index = 4 # D
	matches = production.matches_left_context(word, index)
	assert(matches == true)

	index = 11 # H
	matches = production.matches_left_context(word, index)
	assert(matches == false)

	index = 23 # P
	matches = production.matches_left_context(word, index)
	assert(matches == true)

	index = 21 # O
	matches = production.matches_left_context(word, index)
	assert(matches == false)

	var p2 = Production.new("","", "D", "")
	index = 5 # E
	matches = p2.matches_left_context(word, index)
	assert(matches == true)

	var p3 = Production.new("","", "C", "")
	index = 8 # F
	matches = p3.matches_left_context(word, index)
	assert(matches == true)

	index = 0 # A
	matches = p3.matches_left_context(word, index)
	assert(matches == false)

	var p4 = Production.new("","", "", "")
	index = 0
	matches = p4.matches_left_context(word, index)
	assert(matches == true)

	index = 1
	matches = p4.matches_left_context(word, index)
	assert(matches == true)

	var p5 = Production.new("","", "MN", "")
	index = 21 # O
	matches = p5.matches_left_context(word, index)
	assert(matches == true)

	var p6 = Production.new("","", "FG", "")
	index = 19 # M
	matches = p6.matches_left_context(word, index)
	assert(matches == true)

func test_context_symbols():
	var context_symbols = {"a": true}
	var word = "a+ab"
	
	var p1 = Production.new("", "", "a", "")
	var matches = p1.matches_left_context(word, 1, context_symbols)
	assert(matches)
	matches = p1.matches_left_context(word, 2, context_symbols)
	assert(matches)
	matches = p1.matches_left_context(word, 3, context_symbols)
	assert(matches)
	matches = p1.matches_left_context(word, 0, context_symbols)
	assert(not matches)
	
	var p2 = Production.new("", "", "aa", "")
	matches = p2.matches_left_context(word, 4, context_symbols)
	assert(matches)
	matches = p2.matches_left_context(word, 3, context_symbols)
	assert(matches)
	matches = p2.matches_left_context(word, 2, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 1, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 0, context_symbols)
	assert(not matches)
	
	context_symbols = {}
	matches = p2.matches_left_context(word, 4, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 3, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 2, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 1, context_symbols)
	assert(not matches)
	matches = p2.matches_left_context(word, 0, context_symbols)

	matches = p2.matches_left_context(word, 4)
	assert(not matches)
	matches = p2.matches_left_context(word, 3)
	assert(not matches)
	matches = p2.matches_left_context(word, 2)
	assert(not matches)
	matches = p2.matches_left_context(word, 1)
	assert(not matches)
	matches = p2.matches_left_context(word, 0)
