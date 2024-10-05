extends CharacterBody3D

@export_node_path("CharacterBody3D") var player_path
var distance_to_player = 1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var current_jump_velocity = 4.5
var current_speed = 5.0

func _physics_process(delta: float) -> void:
	if player_path:
		calculate_distance_to_player()
		calculate_size()
		calculate_jump()
		calculate_speed()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * (distance_to_player/15)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = current_jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "none", "none")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

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
