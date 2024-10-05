extends Area3D

@onready var marker = $Marker3D
var move_player_speed
var player

func _on_body_entered(body: Node3D) -> void:
	if body.name == 'Character':
		player = body
		Globals.looking_at_city = true


func _on_body_exited(body: Node3D) -> void:
	if body.name == 'Character':
		Globals.alcancou_vista = false
		Globals.looking_at_city = false

func _physics_process(delta: float) -> void:
	if Globals.looking_at_city and !Globals.alcancou_vista:
		move_player_to_marker()

func move_player_to_marker():
	var target_position = marker.global_position
	var speed = 0.5

	var direction = player.global_position.direction_to(target_position)
	var distancia = player.global_transform.origin.distance_to(marker.global_transform.origin)
	
	if distancia < 0.19:
		Globals.alcancou_vista = true
	else:
		player.velocity = direction * speed
		player.move_and_slide()
