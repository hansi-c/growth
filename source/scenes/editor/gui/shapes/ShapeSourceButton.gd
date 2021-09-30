extends OptionButton

const CIRCLE = "Circle"
const RECTANGLE = "Rectangle"
const TRIANGLE = "Triangle"
#const PRIMITIVE = "Primitive"
const FILE = "Image"

signal circle_selected
signal rectangle_selected
signal triangle_selected
signal image_selected

# maps from SelectShapeButton configuration name (String) to self index (int)
var _configured_shapes: Dictionary = {}
#onready var select_shape_button = get_node_or_null("../SelectShapeButton")

func _ready():
	add_item(CIRCLE)
	add_item(RECTANGLE)
	add_item(TRIANGLE)
#	add_item(PRIMITIVE)
	add_item(FILE)
#	select(0)

#func _on_disable_shape_dependent_buttons(value):
#	disabled = value

#func _on_SelectShapeButton_configuration_selected(name):
#	var index = 0
#	if configured_shapes.has(name):
#		index = configured_shapes[name]
#		select(index)
#	else:
#		select(index)
#		emit_signal("item_selected", index)

func _on_ShapeSourceButton_item_selected(index):
	var name = get_item_text(index)
	if name == CIRCLE:
		emit_signal("circle_selected")
	elif name == RECTANGLE:
		emit_signal("rectangle_selected")
	elif name == RECTANGLE:
		emit_signal("triangle_selected")
	elif name == RECTANGLE:
		emit_signal("image_selected")

func _on_SelectShapeButton_configuration_deleted(name):
	if _configured_shapes.has(name):
		_configured_shapes.erase(name)
		if _configured_shapes.empty():
			select(0)
			disabled = true


func _on_configuration_selected(name):
	disabled = false
	if not _configured_shapes.has(name):
		select(0)
