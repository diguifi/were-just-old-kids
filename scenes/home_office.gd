extends Node3D

@onready var audio_notification = $AudioStreamPlayer
var time_looking_at_sprite = 0
var time_to_show_sprite = 5

func _ready() -> void:
	audio_notification.play()
	Globals.sprite_visible = false

func _physics_process(delta: float) -> void:
	calculate_looking_at_sprite(delta)
	
func calculate_looking_at_sprite(delta):
	if !Globals.sprite_visible:
		if Globals.alcancou_vista and (Globals.road_trip_head_rotation.y >= 0.3 and Globals.road_trip_head_rotation.y < 1.4 and Globals.road_trip_head_rotation.x > -0.5 and Globals.road_trip_head_rotation.x < 0.5):
			time_looking_at_sprite+=delta
			if time_looking_at_sprite >= time_to_show_sprite:
				Globals.sprite_visible = true
		else:
			time_looking_at_sprite = 0
