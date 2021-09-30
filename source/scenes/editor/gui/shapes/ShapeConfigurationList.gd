extends ItemList

var number: int = 0

signal configuration_selected(name)

func _on_add_new_configuration():
	var name = _create_new_name()
	add_item(name)
	update()

func _create_new_name() -> String:
	number += 1
	var result = "Shape_" + str(number)
	return result

func _on_delete_configuration():
	for index in get_selected_items():
		remove_item(index)


func _on_ShapeConfigurationList_item_selected(index):
	var name: String = get_item_text(index)
	emit_signal("configuration_selected", name)
