extends Area3D

func _ready():
	body_entered.connect(_on_player_entered)
	print("Ground level zone ready")

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		show_room("FirstFloor/TrainingStuff1")
		
		# Unload SecondFloor (can't see it from here)
		hide_room("SecondFloor/TrainingStuff2")

func show_room(room_name):
	var room = get_node("../" + room_name)
	if room:
		room.visible = true
		room.process_mode = Node.PROCESS_MODE_INHERIT
		print("Loaded: " + room_name)

func hide_room(room_name):
	var room = get_node("../" + room_name)
	if room:
		room.visible = false
		room.process_mode = Node.PROCESS_MODE_DISABLED
		print("UnLoaded: " + room_name)
