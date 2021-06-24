extends ProductionEdit
class_name PredecessorEdit

func _on_text_changed(text: String):
	production.predecessor = text
