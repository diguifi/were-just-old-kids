extends CharacterBody3D

@export_node_path("CharacterBody3D") var player_path
@onready var anim = $AnimatedSprite3D
@onready var animator = $AnimationPlayer
var distance_to_player = 1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var current_jump_velocity = 4.5
var current_speed = 5.0
var initial_position
var appearing = false
var appeared = false
var touched_wall_last_time = false
var custom_is_on_wall = false

func _ready() -> void:
	anim.play("default")
	initial_position = position
	visible = false

func _physics_process(delta: float) -> void:
	appear()
	if player_path:
		calculate_distance_to_player()
		calculate_size()
		calculate_jump()
		calculate_speed()
		
	if appeared and Globals.sprite_visible:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta * (distance_to_player/15)
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			anim.play("jump")
			velocity.y = current_jump_velocity

		# Get the input direction and handle the movement/deceleration.
		var direction
		var input_dir := Input.get_vector("ui_left", "ui_right", "none", "none")
		
		calculate_is_on_wall(input_dir.x == 1)
		
		if input_dir.x == 1 and Globals.goal and (!custom_is_on_wall or !is_on_floor()):
			direction = global_position.direction_to(Globals.goal.global_transform.origin)
		if input_dir.x == -1 and Globals.goal and (!custom_is_on_wall or !is_on_floor()):
			direction = global_position.direction_to(Globals.goal.previous_goal)
			
		if direction:
			if !Input.is_action_just_pressed("ui_accept") and is_on_floor():
				anim.play("walk")
			velocity.x = direction.x * current_speed
			velocity.z = direction.z * current_speed
		else:
			if !Input.is_action_just_pressed("ui_accept") and is_on_floor():
				anim.play("default")
			velocity.x = move_toward(velocity.x, 0, current_speed)
			velocity.z = move_toward(velocity.z, 0, current_speed)
			
		calculate_goal()
		if !touched_wall_last_time or !is_on_floor():
			touched_wall_last_time = is_on_wall()
		else:
			touched_wall_last_time = custom_is_on_wall
		
		if Globals.looking_at_city:
			move_and_slide()

func calculate_distance_to_player():
	var player = get_node(player_path)
	distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
		
func calculate_size():
	scale.x = distance_to_player/10
	scale.y = distance_to_player/10

func calculate_jump():
	current_jump_velocity = JUMP_VELOCITY * (distance_to_player/12)
	
func calculate_speed():
	current_speed = SPEED * (distance_to_player/20)

func died():
	position = initial_position
	Globals.goal.reset()

func calculate_goal():
	if Globals.goal and global_transform.origin.distance_to(Globals.goal.global_transform.origin) < 9:
		Globals.goal.go_to_next_position()

func appear():
	if Globals.sprite_visible and !appearing:
		appearing = true
		visible = true
	if appearing and !appeared and !animator.is_playing():
		animator.play("appear")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	appeared = true

func calculate_is_on_wall(moving_right):
	if !is_on_wall() and touched_wall_last_time and moving_right:
		custom_is_on_wall = true
	else:
		custom_is_on_wall = is_on_wall()
