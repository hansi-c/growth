extends Node

func _ready():
	test_apply_rule()

func test_apply_rule():
	var grammar = Grammars.Grammar.new()
	grammar.rules = {
		"0" : "Zero",
		"1" : "One",
		"2" : "Two"
	}

	var word = "0"
	var result = grammar.apply_rule(word, 0)
	print(result)
	assert(result == "Zero")

	word = "012"
	result = grammar.apply_rule(word, 0)
	print(result)
	assert(result == "Zero12")
	result = grammar.apply_rule(word, 1)
	print(result)
	assert(result == "0One2")
	result = grammar.apply_rule(word, 2)
	print(result)
	assert(result == "01Two")

	# expect an error to be thrown here
	word = "+"
	result = grammar.apply_rule(word, 0)
	print(result)
	assert(result == "")
