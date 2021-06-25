extends LineEdit

func _on_grammar_modified(grammar: ILGrammar):
	var alphabet = grammar.alphabet()
	print("%s (%s)" % [alphabet, alphabet.size()])
	set_text(_alphabet_to_string(alphabet))

func _alphabet_to_string(alphabet: Array):
	var result = ""
	var first = true
	for s in alphabet:
		if not first:
			result += " "
		result += s
		first = false
	return result
