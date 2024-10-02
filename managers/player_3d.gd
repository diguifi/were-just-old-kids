extends CharacterBody3D

@onready var sprite_anim = $AnimatedSprite3D
@onready var animation = $AnimationPlayer
@onready var jump_audio = $Jump
@onready var hurt_audio = $Hurt
@export var jump_velocity : float = 6
@export var hurt_time = 1.5
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var was_on_floor = true
var starting_x = 0
var is_hurt = false
var hurt_count = 0
var just_released = false
var just_appeared = false
var alive = false

func _ready():
	visible = false
	starting_x = global_transform.origin.x
	sprite_anim.play("walk")

func _physics_process(delta):
	handle_birth()
	global_transform.origin.x = starting_x
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	handle_hurt(delta)
	handle_jumping()
	move_and_slide()
	
	if !was_on_floor and is_on_floor():
		sprite_anim.play("walk")
	was_on_floor = is_on_floor()
	
func handle_birth():
	if !just_appeared and Globals.sprite_visible:
		visible = true
		just_appeared = true
		animation.play("appear")

func handle_jumping():
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		if alive:
			jump_audio.play()
		sprite_anim.play("jump")
		velocity.y += jump_velocity
		
	if Input.is_action_just_released("ui_accept") and velocity.y > 0:
		just_released = true
	
	if just_released and velocity.y > 0:
		velocity.y = lerpf(velocity.y,0.0,0.2)
	else:
		just_released = false
		
func handle_hurt(delta):
	if alive and is_hurt:
		if Engine.get_frames_drawn() % 2 == 0:
			visible = !visible
		hurt_count += delta
		if hurt_count >= hurt_time:
			is_hurt = false
			visible = true
			sprite_anim.play("walk")

func hurt():
	if alive:
		hurt_count = 0
		is_hurt = true
		sprite_anim.play("hurt")
		hurt_audio.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'appear':
		alive = true
