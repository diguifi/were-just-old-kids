extends Node

@onready var end_audio = $AudioStreamPlayer
var time_looking_at_sprite = 0
var time_to_show_sprite = 5
var time_playing_level = 0
var time_to_next_level = 20
var called_new_level = false
var time_keyboard = 0
var time_to_start_keyboard = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calculate_looking_at_sprite(delta)
	if Globals.sprite_visible:
		play_keyboard(delta)
		time_playing_level += delta
		if time_playing_level > time_to_next_level:
			change_level()

func calculate_looking_at_sprite(delta):
	Globals.looking_at_gb = Globals.road_trip_head_rotation.y < -1.2 and Globals.road_trip_head_rotation.x < -0.1
	if !Globals.sprite_visible:
		if Globals.road_trip_head_rotation.y >= -0.3 and Globals.road_trip_head_rotation.x > -0.4 and Globals.road_trip_head_rotation.x < 0.14:
			time_looking_at_sprite+=delta
			if time_looking_at_sprite >= time_to_show_sprite:
				Globals.sprite_visible = true
		else:
			time_looking_at_sprite = 0
	
func change_level():
	if !called_new_level:
		called_new_level = true
		get_tree().change_scene_to_file("res://scenes/home_office.tscn")

func play_keyboard(delta):
	time_keyboard += delta
	if time_keyboard > time_to_start_keyboard:
		if !end_audio.playing:
			end_audio.play()
