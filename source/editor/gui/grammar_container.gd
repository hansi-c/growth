extends GridContainer

onready var grammar: ILGrammar = Globals.grammar
onready var alphabet_textbox = get_node("/root/GrammarEditor/GUI/Indented/AlphabetTextBox")
var _row_index: int
var _delete_groups = {}
var _row_group_prefix = "_row"

#signal grammar_modified(grammar)

func _ready():
	if grammar == null:
		grammar = Grammars.identity_grammar()
		var production_picker = StochasticProductionPicker.new(Globals.rng_state.rng)
		grammar.set_production_picker(production_picker)
	_setup_grammar_table()
	print(grammar)

func _setup_grammar_table():
	for s in grammar.productions:
		var ps = grammar.productions[s]
		for p in ps:
			add_row(p)

func add_row(production: Production):
	var left_context = LeftContextEdit.new()
	left_context.set_text(production.left_context)
	left_context.set_expand_to_text_length(true)
	left_context.production = production
	left_context.connect("text_changed", left_context, "_on_text_changed")
	var predecessor = _create_predecessor_edit(production)
	var successor = SuccessorEdit.new()
	successor.set_text(production.successor)
	successor.set_expand_to_text_length(true)
	successor.production = production
	successor.connect("text_changed", successor, "_on_text_changed")
	var probability = ProbabilityEdit.new()
	probability.set_text("%s" % production.probability_factor)
	probability.set_align(LineEdit.ALIGN_RIGHT)
	probability.set_expand_to_text_length(true)
	probability.production = production
	probability.connect("text_changed", probability, "_on_text_changed")
	var row_group = _row_group_prefix + str(_row_index)
	var delete_button = _create_delete_button(row_group)
	_add_cell(left_context, row_group)
	_add_cell(predecessor, row_group)
	_add_cell(successor, row_group)
	_add_cell(probability, row_group)
	_add_cell(delete_button, row_group)
	_row_index += 1

func _create_predecessor_edit(production: Production):
	var predecessor = PredecessorEdit.new()
	predecessor.set_max_length(1)
	predecessor.set_text(production.predecessor)
	predecessor.production = production
	predecessor.connect("text_changed", predecessor, "_on_text_changed")
	return predecessor

#func _on_predecessor_modified(text: String):
#	emit_signal("grammar_modified", grammar)

func _create_delete_button(row_group: String):
	var delete_button = Button.new()
	delete_button.set_text("-")
	delete_button.connect("button_up", self, "_on_delete_row", [row_group], CONNECT_ONESHOT)
	return delete_button

func _add_cell(node: Node, delete_group: String):
	add_child(node)
	node.add_to_group(delete_group)

func _on_add_production_button_button_up():
	var production = Production.new("", "")
	grammar.add_production(production)
	add_row(production)
	print(grammar)

func _on_delete_row(row_group: String):
		get_tree().call_group_flags(SceneTree.GROUP_CALL_UNIQUE, row_group, "queue_free")
		
