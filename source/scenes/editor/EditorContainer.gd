extends TabContainer

func _ready():
	set_current_tab(Globals.last_editor_tab)

func _on_BackButton_button_up():
	Globals.last_editor_tab = get_current_tab()
