extends LineEdit

func _on_alphabet_changed(grammar: ILGrammar):
	var alphabet = grammar.alphabet_to_string()
	set_text(alphabet)
