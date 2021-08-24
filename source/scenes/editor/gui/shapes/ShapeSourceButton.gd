extends OptionButton

# maps from SelectShapeButton configuration name (String) to self index (int)
var configured_shapes: Dictionary = {}
onready var select_shape_button = get_node_or_null("../SelectShapeButton")

func _ready():
	add_item("Triangle")
	add_item("Rectangle")
	add_item("Circle")
	add_item("File...")

func _on_disable_shape_dependent_buttons(value):
	disabled = value

func _on_SelectShapeButton_configuration_selected(name):
	var index = 0
	if configured_shapes.has(name):
		index = configured_shapes[name]
	select(index)
	emit_signal("item_selected", index)

func _on_ShapeSourceButton_item_selected(index):
	var configuration_index = select_shape_button.get_selected()
	var name = select_shape_button.get_item_text(configuration_index)
	configured_shapes[name] = index

func _on_SelectShapeButton_configuration_deleted(name):
	if configured_shapes.has(name):
		configured_shapes.erase(name)
		if configured_shapes.empty():
			select(0)
			disabled = true
