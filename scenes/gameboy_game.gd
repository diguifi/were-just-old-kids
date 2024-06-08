extends Node2D

@onready var sprite = $Player
@onready var brackground = $Background
@onready var points_label = $Points
@onready var pause_label = $Pause
var jumping = false
var jump_time = 0
var max_jump_time = 0.6
var height = 0
var is_hurt = false
var hurt_count = 0
var hurt_time = 2
var points = 0
var points_step = 10
var is_paused = false
var shader_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")
	height = sprite.sprite_frames.get_frame_texture('default', 0).get_height() * sprite.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_pause(delta)
	if !is_paused:
		handle_jumping(delta)
		handle_hurt(delta)

func handle_jumping(delta):
	if Input.is_action_just_pressed("ui_accept") and !jumping:
		jumping = true
		sprite.transform.origin.y -= height
	if jumping:
		jump(delta)
		
func jump(delta):
	sprite.play('jump')
	jump_time += delta
	if jump_time >= max_jump_time:
		jump_time = 0
		jumping = false
		sprite.play("default")
		sprite.transform.origin.y += height

func handle_hurt(delta):
	if is_hurt:
		if Engine.get_frames_drawn() % 5 == 0:
			sprite.visible = !sprite.visible
		hurt_count += delta
		if hurt_count >= hurt_time:
			is_hurt = false
			sprite.visible = true
			
func handle_pause(delta):
	is_paused = !Globals.looking_at_gb
	pause_label.visible = is_paused
	if !is_paused:
		sprite.play()
		brackground.get_material().set_shader_parameter("time", shader_time)
		shader_time += delta
	else:
		sprite.pause()

func hurt():
	if points - points_step >= 0:
		points -= points_step
		points_label.text = str(points)
	hurt_count = 0
	is_hurt = true

func add_points():
	points += points_step
	points_label.text = str(points)
