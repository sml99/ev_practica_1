extends Area3D

func _ready():
	body_entered.connect(_on_player_entered)

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		# Keep SecondFloor visible when on upper level
		show_room("SecondFloor/TrainingStuff2")
		# Cull ground level rooms when upstairs
		hide_room("FirstFloor/TrainingStuff1")

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
