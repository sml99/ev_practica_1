extends CharacterBody3D

@onready var yaw_node = $Yaw
@onready var camera = $Yaw/Camera3D
@onready var info_label = $ControlsLabel/UI/InfoLabel
@onready var interaction_label = $ControlsLabel/UI/InteractionLabel


@export var mouse_sensitivity = 0.002
@export var movement_speed = 5.0
@export var jump_velocity = 2
var pitch_angle = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	# Mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal rotation (Yaw)
		yaw_node.rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Vertical rotation (Pitch) with limits
		pitch_angle -= event.relative.y * mouse_sensitivity
		pitch_angle = clamp(pitch_angle, -1.5, 1.5)
		camera.rotation.x = pitch_angle
		

	# Right-click to show/hide mouse for clicking
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			toggle_mouse_mode()

	
	# Mouse look (ONLY when captured)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw_node.rotate_y(-event.relative.x * mouse_sensitivity)
		pitch_angle -= event.relative.y * mouse_sensitivity
		pitch_angle = clamp(pitch_angle, -1.5, 1.5)
		camera.rotation.x = pitch_angle

func toggle_mouse_mode():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("Mouse visible - can click objects")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		print("Mouse captured - can look around")

func show_interaction_prompt(text: String):
	if interaction_label:
		interaction_label.text = text
		interaction_label.visible = true
		print("Show E")

func hide_interaction_prompt():
	if interaction_label:
		interaction_label.visible = false
		print("Hide E")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# WASD Movement
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	# Apply movement with collision detection
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		var direction = Vector3(input_vector.x, 0, input_vector.y)
		direction = yaw_node.transform.basis * direction
		velocity.x = direction.x * movement_speed
		velocity.z = direction.z * movement_speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	if info_label:
		var pos = global_position
		info_label.text = "Position: %.1f, %.1f, %.1f\nOn Floor: %s" % [pos.x, pos.y, pos.z, is_on_floor()]

	
	move_and_slide()
