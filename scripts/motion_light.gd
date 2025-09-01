extends Node3D

@onready var light = $Light
@onready var motion_sensor = $MotionSensor

@export var light_energy_max: float = 1.5
@export var fade_in_time: float = 0.3
@export var fade_out_delay: float = 3.0
@export var fade_out_time: float = 1.0

var player_in_range = false
var fade_out_timer: Timer
var current_tween: Tween

func _ready():
	# Connect motion sensor signals
	motion_sensor.body_entered.connect(_on_player_entered)
	motion_sensor.body_exited.connect(_on_player_exited)
	
	# Create fade-out timer
	fade_out_timer = Timer.new()
	fade_out_timer.wait_time = fade_out_delay
	fade_out_timer.one_shot = true
	fade_out_timer.timeout.connect(_start_fade_out)
	add_child(fade_out_timer)
	
	# Start with light off
	light.light_energy = 0.0
	print("Motion light ready at: ", global_position)

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_in_range = true
		fade_out_timer.stop()  # Cancel any pending fade-out
		fade_in_light()
		print("Motion detected - light ON")

func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_in_range = false
		fade_out_timer.start()  # Start fade-out delay
		print("Motion ended - light will turn OFF in ", fade_out_delay, " seconds")

func fade_in_light():
	# Stop any existing tween
	if current_tween:
		current_tween.kill()
	
	# Fade in smoothly
	current_tween = create_tween()
	current_tween.tween_property(light, "light_energy", light_energy_max, fade_in_time)

func _start_fade_out():
	if not player_in_range:  # Double-check player still gone
		fade_out_light()

func fade_out_light():
	# Stop any existing tween
	if current_tween:
		current_tween.kill()
	
	# Fade out smoothly
	current_tween = create_tween()
	current_tween.tween_property(light, "light_energy", 0.0, fade_out_time)
	print("Motion light fading out...")
