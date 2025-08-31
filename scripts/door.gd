extends StaticBody3D

@onready var animation_player = $AnimationPlayer
@onready var click_area = $ClickArea

var door_open = false
var player_nearby = false

func _ready():
	# Connect BOTH mouse clicks AND proximity detection
	click_area.input_event.connect(_on_click_area_input_event)
	click_area.body_entered.connect(_on_player_entered)
	click_area.body_exited.connect(_on_player_exited)
	print("Interactive door ready! (Mouse click OR E key)")

# MOUSE INTERACTION (when cursor is visible)
func _on_click_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			toggle_door()
			print("Door clicked with mouse!")

# PROXIMITY DETECTION (for E key)
func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_nearby = true
		print("Press E to interact with door")
		body.show_interaction_prompt("Press E to open/close door")


func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_nearby = false
		print("Moved away from door")
		body.hide_interaction_prompt()

# E KEY INTERACTION (only when nearby)
func _process(delta):
	if player_nearby and Input.is_action_just_pressed("interact"):
		toggle_door()
		print("Door opened with E key!")

func toggle_door():
	if door_open:
		animation_player.play_backwards("door_open")
		door_open = false
		print("Door closing...")
	else:
		animation_player.play("door_open")
		door_open = true
		print("Door opening...")
