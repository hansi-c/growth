extends LinkButton

onready var file_dialog = $FileDialog
var file_path: String

func _on_FileDialog_file_selected(path):
	file_path = path
	var relative_name = file_path
	var last_index = file_path.find_last("/")
	if last_index >= 0:
		relative_name = file_path.substr(last_index)
		if last_index + 1 < file_path.length():
			relative_name = file_path.substr(last_index + 1)
	set_text(relative_name)

func _on_self_button_up():
	file_dialog.popup_centered_ratio()
