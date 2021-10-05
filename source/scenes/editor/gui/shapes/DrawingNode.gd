extends Node2D

onready var stem_node = $StemNode
onready var attachment_node = $AttachmentRect
onready var circle_rect = $AttachmentRect/CircleRect
onready var rectangle_rect = $AttachmentRect/RectangleRect
onready var texture_rect = $AttachmentRect/TextureRect
var attachment_pos: Vector2
var stem_pos: Vector2

func _process(_delta):
	attachment_pos = attachment_node.get_position() \
		+ attachment_node.get_pivot_offset()
	stem_pos = stem_node.get_position()
	update()

func _draw():
	var attachment_color: Color = attachment_node.get_frame_color()
	draw_line(attachment_pos, stem_pos, attachment_color)

func _on_ShapeSourceButton_circle_selected():
	circle_rect.show()
	rectangle_rect.hide()
	texture_rect.hide()

func _on_ShapeSourceButton_rectangle_selected():
	circle_rect.hide()
	rectangle_rect.show()
	texture_rect.hide()

func _on_ShapeSourceButton_image_selected():
	circle_rect.hide()
	rectangle_rect.hide()
	texture_rect.show()
