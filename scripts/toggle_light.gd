extends SpotLight3D

@onready var animation_player = $LightAnimator

func _process(delta):
	if Input.is_action_just_pressed("toggle_light"):
		animation_player.play("light_flicker")
