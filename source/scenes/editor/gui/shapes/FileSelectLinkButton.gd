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
	var relative_name: String = path
	var last_index = relative_name.find_last("/")
	if last_index >= 0:
		relative_name = relative_name.substr(last_index)
		if not relative_name.empty():
			relative_name = relative_name.substr(1)
	return relative_name

func _on_self_button_up():
	file_dialog.popup_centered_ratio()

func _load_image(path: String) -> Texture:
	return load(path) as Texture
