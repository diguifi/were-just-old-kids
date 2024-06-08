extends Node3D

var speed = 5

func _physics_process(delta):
	speed = Globals.world_speed
	global_transform.origin.x -= delta * speed
	if global_transform.origin.x < -12:
		queue_free()
