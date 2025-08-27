extends Node3D

@onready var animation_player = $"../AnimationPlayer2"

var door_open = false

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"): 
		if not door_open:
			_handle_door()

func _handle_door():
	door_open = true
	
	# Play forward (open door)
	animation_player.play("door_open")
	
	# Wait 3 seconds
	await get_tree().create_timer(3.0).timeout
	
	# Play backward (close door)
	animation_player.play_backwards("door_open")
	door_open = false
