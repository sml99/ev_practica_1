extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var click_area: Area3D = $ClickArea

var door_open := false
var player_nearby := false

func _ready():
	# Input: mouse on Area3D, proximity via body_entered/exited
	if click_area:
		click_area.input_event.connect(_on_click_area_input_event)
		click_area.body_entered.connect(_on_player_entered)
		click_area.body_exited.connect(_on_player_exited)

func _process(_delta):
	# Gate interaction by proximity
	if player_nearby and not door_open:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("pass_nft"):
			_handle_door()

# Mouse click (also requires proximity)
func _on_click_area_input_event(_camera, event, _event_position, _normal, _shape_idx):
	if not player_nearby or door_open:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_handle_door()

# Proximity enter/exit
func _on_player_entered(body):
	if body.name == "FPSPlayer":
		player_nearby = true
		if body.has_method("show_interaction_prompt"):
			body.show_interaction_prompt("Press E to use pass")

func _on_player_exited(body):
	if body.name == "FPSPlayer":
		player_nearby = false
		if body.has_method("hide_interaction_prompt"):
			body.hide_interaction_prompt()

func _handle_door():
	door_open = true
	
	# Play forward (open door)
	animation_player.play("DoorAction")
	
	# Wait 3 seconds
	await get_tree().create_timer(3.0).timeout
	
	# Play backward (close door)
	animation_player.play_backwards("DoorAction")
	door_open = false
