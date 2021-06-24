extends ProductionEdit
class_name LeftContextEdit

func _on_text_changed(text: String):
	production.left_context = text
