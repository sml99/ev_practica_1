extends StaticBody3D

@onready var animation_player = $AnimationPlayer
@onready var click_area = $ClickArea

var door_open = false
var player_nearby = false

func _ready():
	# Input: mouse on Area3D, proximity via body_entered/exited
	click_area.input_event.connect(_on_click_area_input_event)
	click_area.body_entered.connect(_on_player_entered)
	click_area.body_exited.connect(_on_player_exited)

# Mouse interaction (cursor visible)
func _on_click_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_door()

# Proximity detection (enables E interaction)
func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_nearby = true
		body.show_interaction_prompt("Press E to open/close door")


func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_nearby = false
		body.hide_interaction_prompt()

# E interaction (only when nearby)
func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		toggle_door()

func toggle_door():
	if door_open:
		animation_player.play_backwards("door_open")
		door_open = false
	else:
		animation_player.play("door_open")
		door_open = true
