extends Node3D

@export var rotation_speed : float = 1.0
@export var vertical_speed : float = 1.0
@export var min_angle : float = deg_to_rad(-70.0)
@export var max_angle : float = deg_to_rad(70.0)

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		rotation.y += rotation_speed * delta
	if Input.is_action_pressed("move_right"):
		rotation.y -= rotation_speed * delta

	if Input.is_action_pressed("move_forward"):
		$PivotX.rotation.x -= vertical_speed * delta
	if Input.is_action_pressed("move_backward"):
		$PivotX.rotation.x += vertical_speed * delta

	var current_x = $PivotX.rotation.x
	$PivotX.rotation.x = clamp(current_x, min_angle, max_angle)
