extends OptionButton

onready var global_grammar = Globals.grammar
var presets = []

signal preset_selected(preset)

func _ready():
	add_presets()
	emit_signal("preset_selected", presets[0])

func add_presets():
	if global_grammar:
		var preset = Preset.new()
		preset.grammar = global_grammar
		preset.config = Turtles.wheat()
		add_preset("Custom", preset)
	
	var wheat = Preset.new()
	wheat.grammar = Grammars.wheat_1l()
	wheat.config = Turtles.wheat()

	var sierpinski_60 = Preset.new()
	sierpinski_60.grammar = Grammars.sierpinski_60()
	sierpinski_60.config = Turtles.sierpinski_60()

	var sierpinski_120 = Preset.new()
	sierpinski_120.grammar = Grammars.sierpinski_120()
	sierpinski_120.config = Turtles.sierpinski_120()

	add_preset("Wheat", wheat)
	add_preset("Sierpinski 60", sierpinski_60)
	add_preset("Sierpinski 120", sierpinski_120)

func add_preset(name: String, preset: Preset):
	presets.append(preset)
	add_item(name)

func _on_item_selected(index):
	emit_signal("preset_selected", presets[index])
