extends Node2D

@onready var intro = $Intro
@onready var base = $BaseMusic
@onready var happy = $HappyMusic
@onready var fades_anim = $AnimationPlayer
var max_volume = -15
var fading = false
var playing = false
var playing_base = false
var playing_happy = false
var just_changed_level = true

func _ready() -> void:
	base.volume_db = -80
	happy.volume_db = -80
	base.play()
	happy.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.level == 0:
		if !intro.playing:
			intro.play()
	if Globals.level == 1:
		calculate_music_forest()
	if Globals.level == 2:
		calculate_music_apartment()
		
func calculate_music_forest():
	if !fading and !playing:
		fading = true
		if intro.playing:
			fades_anim.play("fade_out_intro")
		playing_base = true
		fades_anim.play("fade_in_base")
		
	if playing and !fading:
		if Globals.calculate_looking_at_forest() and !playing_happy:
			playing_happy = true
			playing_base = false
			fading = true
			fades_anim.play("fade_out_base")
			fades_anim.play("fade_in_happy")
		if !Globals.calculate_looking_at_forest() and !playing_base:
			playing_happy = false
			playing_base = true
			fading = true
			fades_anim.play("fade_in_base")
			fades_anim.play("fade_out_happy")
			
func calculate_music_apartment():
	if just_changed_level:
		just_changed_level = false
		playing_happy = false
		playing_base = false
		base.volume_db = -80
		happy.volume_db = -80
	if Globals.calculate_looking_at_city() and !playing_happy:
		playing_happy = true
		fading = true
		fades_anim.play("fade_in_happy")
	if !Globals.calculate_looking_at_city() and playing_happy:
		playing_happy = false
		fading = true
		fades_anim.play("fade_out_happy")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	intro.stop()
	playing = true
	fading = false
