extends Node3D

@onready var audio_notification = $AudioStreamPlayer
var time_to_show_sprite = 5

func _ready() -> void:
	audio_notification.play()
	Globals.sprite_visible = false
	Globals.level = 2

func _physics_process(delta: float) -> void:
	calculate_looking_at_sprite(delta)
	
func calculate_looking_at_sprite(delta):
	if !Globals.sprite_visible:
		if Globals.calculate_looking_at_city():
			Globals.time_looking_at_sprite2+=delta
			if Globals.time_looking_at_sprite2 >= time_to_show_sprite:
				Globals.sprite_visible = true
		else:
			Globals.time_looking_at_sprite2 = 0
