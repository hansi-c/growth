extends TextEdit

func _on_grammar_modified(grammar: ILGrammar):
	set_text(str(grammar.alphabet()))
