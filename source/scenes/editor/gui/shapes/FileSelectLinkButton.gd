extends LinkButton

onready var file_dialog = $FileDialog
var file_path: String

signal texture_loaded(texture)

func _on_FileDialog_file_selected(path: String):
	file_path = path
	var texture = _load_image(path)
	if texture:
		emit_signal("texture_loaded", texture)
	_update_text(path)

func _update_text(path: String):
	var relative_name = _extract_relative_filename(path)
	set_text(relative_name)

func _extract_relative_filename(path: String) -> String:
	var relative_name = file_path
	var last_index = file_path.find_last("/")
	if last_index >= 0:
		relative_name = file_path.substr(last_index)
		if last_index + 1 < file_path.length():
			relative_name = file_path.substr(last_index + 1)
	return relative_name

func _on_self_button_up():
	file_dialog.popup_centered_ratio()

func _load_image(path: String) -> Texture:
	return load(path) as Texture
