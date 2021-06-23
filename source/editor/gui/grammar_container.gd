extends GridContainer

onready var grammar: ILGrammar = Globals.grammar
var _row_index: int
var _delete_groups = {}
var _delete_group_prefix = "_delete"

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
	var left_context = LineEdit.new()
	left_context.set_text(production.left_context)
	left_context.set_expand_to_text_length(true)
	var predecessor = LineEdit.new()
	predecessor.set_max_length(1)
	predecessor.set_text(production.predecessor)
	var successor = LineEdit.new()
	successor.set_text(production.successor)
	successor.set_expand_to_text_length(true)
	var probability = LineEdit.new()
	probability.set_text("%s" % production.probability_factor)
	probability.set_align(LineEdit.ALIGN_RIGHT)
	probability.set_expand_to_text_length(true)
	var delete_group = _delete_group_prefix + str(_row_index)
	var delete_button = _create_delete_button(delete_group)
	_add_cell(left_context, delete_group)
	_add_cell(predecessor, delete_group)
	_add_cell(successor, delete_group)
	_add_cell(probability, delete_group)
	_add_cell(delete_button, delete_group)
	_row_index += 1

func _create_delete_button(delete_group: String):
	var delete_button = Button.new()
	delete_button.set_text("-")
	delete_button.connect("button_up", self, "_on_delete_row", [delete_group], CONNECT_ONESHOT)
	return delete_button

func _add_cell(node: Node, delete_group: String):
	add_child(node)
	node.add_to_group(delete_group)

func _on_add_production_button_button_up():
	var production = Production.new("", "")
	grammar.add_production(production)
	add_row(production)

func _on_delete_row(delete_group: String):
		get_tree().call_group_flags(SceneTree.GROUP_CALL_UNIQUE, delete_group, "queue_free")
		
