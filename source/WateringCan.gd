extends Node2D

var mouse_position
var animation_finished = false
var watercan_mode = false

func _input(event): 
	if event is InputEventMouseButton :
		print (event.position)

func _process(delta):
	mouse_position = get_global_mouse_position()
	
	if watercan_mode :
		self.position = mouse_position
		if Input.is_action_pressed("click_l"):
			if not animation_finished:
				$AnimationPlayer.play("Water")
				animation_finished = true
			$Particles2D.emitting = true
		if Input.is_action_just_released("click_l"):
			$AnimationPlayer.play_backwards("Water")
			$Particles2D.emitting = false
			animation_finished = false


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			watercan_mode = true
			print ("clicked")
		else:
			print ("Object release")


func _on_Area2D_mouse_entered():
	print ("cursor entered")
