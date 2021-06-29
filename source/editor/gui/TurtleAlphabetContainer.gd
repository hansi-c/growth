extends HBoxContainer

#onready var abilties_container = get_node("/root/Turtles/AbiltiesContainer")

signal add_ability_symbol(symbol)

func _on_alphabet_changed(grammar: ILGrammar):
	var children_to_delete = get_children()
	var alphabet = grammar.alphabet()
	for symbol in alphabet:
		add_symbol_button(symbol)
	for child in children_to_delete:
		child.queue_free()

func add_symbol_button(symbol: String):
	var button = Button.new()
	button.set_text(symbol)
	add_child(button)
	button.connect("button_up", self, "_on_symbol_button_up", [button])

func _on_symbol_button_up(button: Button):
	button.set_disabled(true)
	var symbol = button.get_text()
	emit_signal("add_ability_symbol", symbol)
