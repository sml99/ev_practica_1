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
	# Motion sensor proximity signals
	motion_sensor.body_entered.connect(_on_player_entered)
	motion_sensor.body_exited.connect(_on_player_exited)
	
	# Fade-out timer
	fade_out_timer = Timer.new()
	fade_out_timer.wait_time = fade_out_delay
	fade_out_timer.one_shot = true
	fade_out_timer.timeout.connect(_start_fade_out)
	add_child(fade_out_timer)
	
	# Initialize with light off
	light.light_energy = 0.0

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_in_range = true
		fade_out_timer.stop()  # cancel pending fade-out
		fade_in_light()

func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_in_range = false
		fade_out_timer.start()  # start fade-out delay

func fade_in_light():
	# Kill active tween before creating new one
	if current_tween:
		current_tween.kill()
	
	# Ease energy to max
	current_tween = create_tween()
	current_tween.tween_property(light, "light_energy", light_energy_max, fade_in_time)

func _start_fade_out():
	if not player_in_range:  # guard: still absent
		fade_out_light()

func fade_out_light():
	# Kill active tween before creating new one
	if current_tween:
		current_tween.kill()
	
	# Ease energy to zero
	current_tween = create_tween()
	current_tween.tween_property(light, "light_energy", 0.0, fade_out_time)
