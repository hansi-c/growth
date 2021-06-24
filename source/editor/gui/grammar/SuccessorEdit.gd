extends ProductionEdit
class_name SuccessorEdit

func _on_text_changed(text: String):
	production.successor = text
