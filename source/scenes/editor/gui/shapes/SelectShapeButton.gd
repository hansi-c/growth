extends OptionButton

var number: int = 1

signal disable_shape_dependent_buttons(value)
signal configuration_selected(name)
signal configuration_deleted(name)

func _on_NewShapeButton_button_up():
	var name = concat_name()
	add_item(name)
	number += 1
	emit_signal("disable_shape_dependent_buttons", false)
	if get_item_count() == 1:
		select(0)
		emit_signal("item_selected", 0)
	
func concat_name():
	return "Shape " + str(number)

func _on_DeleteShapeButton_button_up():
	var name = get_item_text(selected)
	var old = selected
	if selected+1 < get_item_count():
		select(selected+1)
	remove_item(old)
	update()
	emit_signal("configuration_deleted", name)
	if get_item_count() < 1:
		clear()
		emit_signal("disable_shape_dependent_buttons", true)
	else:
#		select(0)
		emit_signal("item_selected", 0)
	update()

func _on_SelectShapeButton_item_selected(index):
	var name = get_item_text(index)
	emit_signal("configuration_selected", name)
	
