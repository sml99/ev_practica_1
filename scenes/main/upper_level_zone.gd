extends Area3D

func _ready():
	body_entered.connect(_on_player_entered)
	print("Upper level zone ready")

func _on_player_entered(body):
	if body.name == "FPSPlayer":
		print("Player entered upper level area")
		
		# Keep SecondFloor loaded
		show_room("SecondFloor/TrainingStuff2")
		
		# Unload ground level areas (can't see them from upstairs)
		#hide_room("EntranceRoom")
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
		print("UnLoaded: " + room_name)
