extends Node2D
var inside_area : bool
var watering_mode : bool
var mouse_position
var animation_finished

func _process(delta):
	mouse_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and inside_area and event.is_pressed() :
		watering_mode = true
	
	if watering_mode :
		self.position = mouse_position
		if watering_mode and event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				if not animation_finished:
					$AnimationPlayer.play("watering")
					$Particles2D.emitting = true
					animation_finished = true
			if event.button_index == BUTTON_LEFT and !event.pressed:
				$AnimationPlayer.play_backwards("watering")
				$Particles2D.emitting = false
				animation_finished = false
	
	if watering_mode and event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			self.position = Vector2(520,280)
			watering_mode = false

func _on_Area2D_mouse_entered():
	inside_area = true
	print ("mouse_enterd")

func _on_Area2D_mouse_exited():
	inside_area = false
	print ("mouse_exitd")
