extends OptionButton

#onready var global_grammar = Globals.grammar
#onready var global_turtle_config = Globals.turtle_config
var presets = []

signal preset_selected(preset)

func _ready():
	add_presets()
	emit_signal("preset_selected", presets[0])

func add_presets():
	if Globals.grammar:
		var preset = Preset.new()
		preset.grammar = Globals.grammar
		if Globals.turtle_settings:
			preset.turtle_settings = Globals.turtle_settings
		else:
			preset.turtle_settings = TurtleSettings.new()
		if Globals.turtle_abilities:
			preset.turtle_abilities = Globals.turtle_abilities
		else:
			preset.turtle_abilities = Turtles.default_abilities()
		add_preset("Custom", preset)
	
	var identity = Preset.new()
	identity.grammar = Grammars.identity_grammar()
	identity.turtle_settings = TurtleSettings.new()
	identity.turtle_abilities = Turtles.default_abilities()
	
	var wheat = Preset.new()
	wheat.grammar = Grammars.wheat_1l()
	wheat.turtle_settings = Turtles.wheat_settings()
	wheat.turtle_abilities = Turtles.wheat_abilities()

	var sierpinski_60 = Preset.new()
	sierpinski_60.grammar = Grammars.sierpinski_60()
	sierpinski_60.turtle_settings = Turtles.sierpinski_60_settings()
	sierpinski_60.turtle_abilities = Turtles.sierpinski_abilities()

	var sierpinski_120 = Preset.new()
	sierpinski_120.grammar = Grammars.sierpinski_120()
	sierpinski_120.turtle_settings = Turtles.sierpinski_120_settings()
	sierpinski_120.turtle_abilities = Turtles.sierpinski_abilities()

	add_preset("Wheat", wheat)
	add_preset("Identity", identity)
	add_preset("Sierpinski 60", sierpinski_60)
	add_preset("Sierpinski 120", sierpinski_120)
	
func add_preset(name: String, preset: Preset):
	presets.append(preset)
	add_item(name)

func _on_item_selected(index):
	emit_signal("preset_selected", presets[index])
