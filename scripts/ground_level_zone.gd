extends Area3D

func _ready():
	body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		show_room("FirstFloor/TrainingStuff1")
		# Cull SecondFloor nodes not visible from ground level
		hide_room("SecondFloor/TrainingStuff2")

func show_room(room_name):
	var room = get_node("../" + room_name)
	if room:
		room.visible = true
		room.process_mode = Node.PROCESS_MODE_INHERIT

func hide_room(room_name):
	var room = get_node("../" + room_name)
	if room:
		room.visible = false
		room.process_mode = Node.PROCESS_MODE_DISABLED
