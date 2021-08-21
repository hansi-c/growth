# TurtleAlphabetContainer.gd
extends HBoxContainer

signal add_ability(symbol)

func _ready():
	for control_symbol in Globals.grammar.control_symbols.enumerate():
		var label = Label.new()
		label.set_text(control_symbol)
		add_child(label)

func _on_alphabet_changed(grammar: ILGrammar):
	var alphabet: Dictionary = grammar.alphabet()
	delete_symbol_buttons(alphabet)
	add_symbol_buttons(alphabet.keys(), grammar.control_symbols.enumerate_dictionary())

func delete_symbol_buttons(alphabet: Dictionary):
	for child in get_children():
		if child is Button:
			var symbol = child.get_text()
			if not alphabet.has(symbol):
				child.queue_free() 

func add_symbol_buttons(alphabet: Array, control_symbols: Dictionary):
	for symbol in alphabet:
		if not control_symbols.has(symbol):
			var has_button = false
			for child in get_children():
				if child is Button and child.get_text() == symbol:
					has_button = true
					break
			if not has_button and not control_symbols.values().has(symbol):
				add_symbol_button(symbol)

func add_symbol_button(symbol: String):
	var button = Button.new()
	button.set_text(symbol)
	add_child(button)
	button.connect("button_up", self, "_on_symbol_button_up", [button])

func _on_symbol_button_up(button: Button):
	var symbol = button.get_text()
	emit_signal("add_ability", symbol)

func _on_ability_added(symbol: String):
	for child in get_children():
		if child is Button and child.get_text() == symbol:
			child.set_disabled(true)

func _on_ability_removed(symbol: String):
	for child in get_children():
		if child is Button and child.get_text() == symbol:
			child.set_disabled(false)
