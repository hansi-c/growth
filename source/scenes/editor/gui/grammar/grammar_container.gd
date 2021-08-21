extends GridContainer

onready var grammar: ILGrammar
var _row_index: int
const _row_group_prefix = "_row"
const table_cell_group = "_table_cell"
var rows = {}

signal alphabet_changed(grammar)
signal axiom_changed(axiom)

func _ready():
	if Globals.grammar == null:
		Globals.grammar = Grammars.identity_grammar()
	grammar = Grammars.duplicate_grammar(Globals.grammar)
	_setup_grammar_table()
	emit_signal("axiom_changed", grammar.axiom)
	emit_signal("alphabet_changed", grammar)

func _setup_grammar_table():
	for s in grammar.productions:
		var ps = grammar.productions[s]
		for p in ps:
			add_row(p)

func add_row(production: Production):
	var row_group = _row_group_prefix + str(_row_index)
	rows[row_group] = production
	_add_cells(production, row_group)

func _add_cells(production: Production, row_group: String):
	var left_context = _create_left_context_edit(production, row_group)
	var predecessor = _create_predecessor_edit(production, row_group)
	var successor = _create_successor_edit(production, row_group)
	var probability = _create_probability_edit(production, row_group)
	var delete_button = _create_delete_button(row_group)
	_add_cell(left_context, row_group)
	_add_cell(predecessor, row_group)
	_add_cell(successor, row_group)
	_add_cell(probability, row_group)
	_add_cell(delete_button, row_group)
	_row_index += 1

func _create_left_context_edit(production: Production, row_group: String):
	var left_context = LineEdit.new()
	left_context.set_text(production.left_context)
	left_context.set_expand_to_text_length(true)
	left_context.connect("text_changed", self, "_on_left_context_changed", [row_group])
	return left_context

func _create_predecessor_edit(production: Production, row_group: String):
	var predecessor = LineEdit.new()
	predecessor.set_max_length(1)
	predecessor.set_text(production.predecessor)
	predecessor.connect("text_changed", self, "_on_predecessor_changed", [row_group])
	return predecessor

func _create_successor_edit(production: Production, row_group: String):
	var successor = LineEdit.new()
	successor.set_text(production.successor)
	successor.set_expand_to_text_length(true)
	successor.connect("text_changed", self, "_on_successor_changed", [row_group])
	return successor

func _create_probability_edit(production: Production, row_group: String):
	var probability = SpinBox.new()
	probability.set_value(production.probability_factor)
	probability.set_align(LineEdit.ALIGN_RIGHT)
	probability.set_step(-1)
	probability.set_max(pow(2, 63))
	probability.connect("value_changed", self, "_on_probability_changed", [row_group])
	return probability

func _create_delete_button(row_group: String):
	var delete_button = Button.new()
	delete_button.set_text("-")
	delete_button.connect("button_up", self, "_on_delete_row", [row_group], CONNECT_ONESHOT)
	return delete_button

func _add_cell(node: Node, row_group: String):
	add_child(node)
	node.add_to_group(row_group)
	node.add_to_group(table_cell_group)

func _on_add_production_button_button_up():
	var production = Production.new("", "")
	grammar.add_production(production)
	add_row(production)
	emit_signal("alphabet_changed", grammar)

func _on_delete_row(row_group: String):
	delete_row(row_group)
	emit_signal("alphabet_changed", grammar)
	
func delete_row(row_group: String):
	grammar.delete_production(rows[row_group])
	get_tree().call_group_flags(SceneTree.GROUP_CALL_UNIQUE, row_group, "queue_free")
	rows.erase(row_group)

func _on_left_context_changed(text: String, row_group: String):
	var production: Production = rows[row_group]
	production.left_context = text
	emit_signal("alphabet_changed", grammar)

func _on_predecessor_changed(text: String, row_group: String):
	var production: Production = rows[row_group]
	production.predecessor = text
	grammar.update_predecessor(production)
	emit_signal("alphabet_changed", grammar)

func _on_successor_changed(text: String, row_group: String):
	var production: Production = rows[row_group]
	production.successor = text
	emit_signal("alphabet_changed", grammar)

func _on_probability_changed(value: float, row_group: String):
	var production: Production = rows[row_group]
	production.probability_factor = value

func _on_Axiom_text_changed(new_text):
	grammar.axiom = new_text
	emit_signal("alphabet_changed", grammar)

func _on_SaveButton_button_up():
	Globals.grammar = grammar
	var error = get_tree().change_scene("res://source/scenes/simulation/grow_zoomable.tscn")
	if error:
		print("could not change scene: %s" % error)

func _on_RevertButton_button_up():
	var nodes_to_delete = _collect_nodes_to_delete()
	rows.clear()
	_row_index = 0
	grammar = Grammars.duplicate_grammar(Globals.grammar)
	_setup_grammar_table()
	for node in nodes_to_delete:
		node.queue_free()
	emit_signal("axiom_changed", grammar.axiom)
	emit_signal("alphabet_changed", grammar)

func _collect_nodes_to_delete() -> Array:
	var result = []
	for node in get_children():
		if node.is_in_group(table_cell_group):
			result.append(node)
	return result
	
