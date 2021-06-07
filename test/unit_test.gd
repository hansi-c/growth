extends Node

func _ready():
	test_apply_rule()
	test_match_left_context()

func test_apply_rule():
	var grammar = ILGrammar.new()
	grammar.productions = {
		"0" : [Production.new("Zero")],
		"1" : [Production.new("One")],
		"2" : [Production.new("Two")]
	}

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

	# expect an error to be thrown here
	word = "+"
	result = grammar.apply_production(word, 0)
	print(result)
	assert(result == "")

func test_match_left_context():
	var production = Production.new("", "ABC", "")
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

	var p2 = Production.new("", "D", "")
	index = 5 # E
	matches = p2.matches_left_context(word, index)
	assert(matches == true)

	var p3 = Production.new("", "C", "")
	index = 8 # F
	matches = p3.matches_left_context(word, index)
	assert(matches == true)

	index = 0 # A
	matches = p3.matches_left_context(word, index)
	assert(matches == false)

	var p4 = Production.new("", "", "")
	index = 0
	matches = p4.matches_left_context(word, index)
	assert(matches == true)

	index = 1
	matches = p4.matches_left_context(word, index)
	assert(matches == true)

	var p5 = Production.new("", "MN", "")
	index = 21 # O
	matches = p5.matches_left_context(word, index)
	assert(matches == true)

	var p6 = Production.new("", "FG", "")
	index = 19 # M
	matches = p6.matches_left_context(word, index)
	assert(matches == true)
