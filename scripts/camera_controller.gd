extends Node

signal switch_to_fps
signal switch_to_surveillance

@onready var fps_camera = $"../FPSPlayer/Yaw/Camera3D"
@onready var surveillance_camera = $"../SurveillanceSystem/SurveillanceCamera"
@onready var fps_player = $"../FPSPlayer"

var current_camera = "fps"

func _ready():
	# Wire camera switch signals
	switch_to_fps.connect(_on_switch_to_fps)
	switch_to_surveillance.connect(_on_switch_to_surveillance)
	
	# Initialize active camera
	fps_camera.current = true
	surveillance_camera.current = false

func _input(_event):
	# Toggle camera on action
	if Input.is_action_just_pressed("switch_camera"): 
		if current_camera == "fps":
			switch_to_surveillance.emit()
		else:
			switch_to_fps.emit()


func _on_switch_to_fps():
	current_camera = "fps"
	fps_camera.current = true
	surveillance_camera.current = false
	# Enable FPS movement and capture mouse
	fps_player.set_process_mode(Node.PROCESS_MODE_INHERIT)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_switch_to_surveillance():
	current_camera = "surveillance"
	fps_camera.current = false
	surveillance_camera.current = true
	# Disable FPS movement and release mouse
	fps_player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
