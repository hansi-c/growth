extends ShapeRect

onready var attachment_end_node = $AttachmentEndRect
var attachment_end_pos: Vector2

func _process(_delta):
	attachment_end_pos = attachment_end_node.get_position() \
		+ attachment_end_node.get_pivot_offset()
	update()

func _draw():
	var attachment_color: Color = get_frame_color()
	draw_line(get_pivot_offset(), attachment_end_pos, attachment_color)
