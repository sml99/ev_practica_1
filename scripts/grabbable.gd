extends RigidBody3D

@onready var grab_area = $GrabArea

var is_grabbed = false
var grabbing_camera = null
var player_nearby = false

func is_player_already_carrying():
	# Check if any RigidBody3D in scene is already grabbed
	var all_bodies = get_tree().get_nodes_in_group("grabbable")
	for body in all_bodies:
		if body != self and body.is_grabbed:
			return true
	return false

func _ready():
	# ADD TO GRABBABLE GROUP
	add_to_group("grabbable")
	
	input_event.connect(_on_input_event)
	if grab_area:
		grab_area.body_entered.connect(_on_player_entered)
		grab_area.body_exited.connect(_on_player_exited)

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_grabbed:
				if not is_player_already_carrying():
					grab_object(camera)
					print("Grabbed ", name, " with mouse!")
				else:
					print("Already carrying something! Drop it first.")
			else:
				release_object()

func _process(delta):
	if is_grabbed:
		follow_camera()
		if Input.is_action_just_pressed("interact"):
			release_object()
			print("Dropped ", name, " with E key!")
			# If still near after dropping, show prompt again
			if player_nearby and not is_player_already_carrying():
				var player = _get_player()
				if player:
					player.show_interaction_prompt("Press E to grab")
			
	elif player_nearby and Input.is_action_just_pressed("interact"):
		if not is_player_already_carrying():
			print("E pressed near ", name)
			var player = _get_player()
			if player:
				var camera = player.get_node("Yaw/Camera3D")
				if camera:
					grab_object(camera)
					print("Grabbed ", name, " with E key!")
		else:
			print("Already carrying something! Drop it first.")

# Proximity + Prompt handling
func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_nearby = true
		if not is_player_already_carrying():
			if not is_grabbed:
				body.show_interaction_prompt("Press E to grab")
			else:
				body.show_interaction_prompt("Press E to drop")
		else:
			body.show_interaction_prompt("Already carrying something!")

func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_nearby = false
		if body.has_method("hide_interaction_prompt"):
			body.hide_interaction_prompt()

# Grab / Drop logic
func grab_object(camera):
	is_grabbed = true
	grabbing_camera = camera
	set_gravity_scale(0)
	set_linear_damp(10.0)
	# DISABLE COLLISION with player when grabbed
	collision_layer = 0
	collision_mask = 0

	# Update prompt to "drop" if in range
	var player = _get_player()
	if player and player_nearby:
		player.show_interaction_prompt("Press E to drop")

func follow_camera():
	if grabbing_camera:
		var target_pos = grabbing_camera.global_position + grabbing_camera.global_transform.basis.z * -1.5
		global_position = global_position.lerp(target_pos, 0.15)

func release_object():
	is_grabbed = false
	grabbing_camera = null
	set_gravity_scale(1.0)
	set_linear_damp(0.1)
	# RE-ENABLE COLLISION when dropped
	collision_layer = 1  
	collision_mask = 1   

	# Update prompt back to "grab" if still in range
	var player = _get_player()
	if player and player_nearby and not is_player_already_carrying():
		player.show_interaction_prompt("Press E to grab")

func _get_player():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_tree().get_root().find_child("FPSPlayer", true, false)
	return player
