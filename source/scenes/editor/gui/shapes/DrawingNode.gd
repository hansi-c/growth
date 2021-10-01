extends Node2D

onready var stem_node = $StemNode
onready var attachment_node = $AttachmentRect
var attachment_pos: Vector2
var stem_pos: Vector2

func _process(delta):
	attachment_pos = attachment_node.get_position() \
		+ attachment_node.get_rect().size/2
	stem_pos = stem_node.get_position()
	update()

func _draw():
	draw_line(attachment_pos, stem_pos, attachment_node.get_frame_color())
