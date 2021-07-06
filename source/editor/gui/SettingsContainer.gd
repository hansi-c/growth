extends GridContainer

onready var start_angle_node = find_node("StartAngleValue")
onready var turn_angle_node = find_node("TurnAngleValue")
onready var line_length_node = find_node("LineLengthValue")
onready var width_falloff_node = find_node("WidthFalloffValue")
var viewmodel: TurtleSettingsModel

func _ready():
	if Globals.turtle_settings == null:
		Globals.turtle_settings = TurtleSettings.new()
	viewmodel = TurtleSettingsModel.new()
	viewmodel.from_turtle_settings(Globals.turtle_settings)
	_initialize_inputs()
	
func _initialize_inputs():
	start_angle_node.set_value(viewmodel.start_angle)
	start_angle_node.connect("value_changed", self, "_on_start_angle_changed")
	turn_angle_node.set_value(viewmodel.turn_angle)
	turn_angle_node.connect("value_changed", self, "_on_turn_angle_changed")
	line_length_node.set_value(viewmodel.line_length)
	line_length_node.connect("value_changed", self, "_on_line_angle_changed")
	width_falloff_node.set_value(viewmodel.width_falloff)
	width_falloff_node.connect("value_changed", self, "_on_width_falloff_changed")

func _on_start_angle_changed(value: float):
	viewmodel.start_angle = value

func _on_turn_angle_changed(value: float):
	viewmodel.turn_angle = value

func _on_line_angle_changed(value: float):
	viewmodel.line_length = value
	
func _on_width_falloff_changed(value: float):
	viewmodel.width_falloff = value
func _on_BackButton_button_up():
	Globals.turtle_settings = viewmodel.to_turtle_settings()
