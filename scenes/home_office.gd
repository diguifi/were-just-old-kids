extends Node3D

@onready var audio_notification = $AudioStreamPlayer
var time_looking_at_sprite = 0
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
			time_looking_at_sprite+=delta
			if time_looking_at_sprite >= time_to_show_sprite:
				Globals.sprite_visible = true
		else:
			time_looking_at_sprite = 0
