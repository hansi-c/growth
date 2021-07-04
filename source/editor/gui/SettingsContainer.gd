extends GridContainer

var turtle_settings: TurtleSettings

func _ready():
	if Globals.turtle_settings == null:
		Globals.turtle_settings = TurtleSettings.new()
	turtle_settings = Turtles.duplicate_settings(Globals.turtle_settings)


func _on_BackButton_button_up():
	Globals.turtle_settings = turtle_settings
