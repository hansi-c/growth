extends Camera2D

func _ready():
	var stem_node = get_node("../GUI/TabContainer/Shapes/BackgroundRect/DrawingNode/StemNode")
	position = stem_node.get_position()
	zoom = Vector2(0.20,.20)

