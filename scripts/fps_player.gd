extends CharacterBody3D

@onready var yaw_node = $Yaw
@onready var camera = $Yaw/Camera3D
@onready var info_label = $ControlsLabel/UI/InfoLabel
@onready var interaction_label = $ControlsLabel/UI/InteractionLabel

@export var mouse_sensitivity = 0.002
@export var movement_speed = 5.0
@export var jump_velocity = 2
@export var sprint_multiplier = 1.4 

var pitch_angle = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Improve InteractionLabel font for readability
	if interaction_label:
		# Use theme overrides if available in the scene (Godot 4)
		interaction_label.add_theme_font_size_override("font_size", 20)
		interaction_label.add_theme_color_override("font_color", Color(1,1,1))
		interaction_label.add_theme_color_override("font_outline_color", Color(0,0,0,0.8))
		interaction_label.add_theme_constant_override("outline_size", 2)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	# Mouse look: integrate relative mouse motion into yaw/pitch
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Yaw: rotate around Y axis
		yaw_node.rotate_y(-event.relative.x * mouse_sensitivity)
		# Pitch: rotate around X axis with clamp
		pitch_angle -= event.relative.y * mouse_sensitivity
		pitch_angle = clamp(pitch_angle, -1.5, 1.5)
		camera.rotation.x = pitch_angle
		

	# Toggle cursor capture with RMB
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			toggle_mouse_mode()


func toggle_mouse_mode():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func show_interaction_prompt(text: String):
	if interaction_label:
		interaction_label.text = text
		interaction_label.visible = true

func hide_interaction_prompt():
	if interaction_label:
		interaction_label.visible = false

func _physics_process(delta):
	# Integrate gravity when not grounded
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	
	# WASD input vector
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_forward"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	# Sprint scalar
	var speed :float = movement_speed
	if Input.is_action_pressed("sprint"):       
		speed *= sprint_multiplier
	
	# Move in camera (yaw) space; project onto XZ plane
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		var direction = Vector3(input_vector.x, 0, input_vector.y)
		direction = yaw_node.transform.basis * direction
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, movement_speed)
		velocity.z = move_toward(velocity.z, 0, movement_speed)
	
	if info_label:
		var pos = global_position
		var sprinting = Input.is_action_pressed("sprint")
		info_label.text = "Position: %.1f, %.1f, %.1f\nOn Floor: %s\nSprinting: %s" % [
			pos.x, pos.y, pos.z, is_on_floor(), sprinting
		]

	move_and_slide()
