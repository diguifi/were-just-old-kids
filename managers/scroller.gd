extends Node3D

var speed = 5
@onready var floor1 = $Floor1
@onready var floor2 = $Floor2
var respawn = 0

func _ready():
	respawn = floor2.global_transform.origin.x

func _physics_process(delta):
	speed = Globals.world_speed
	
	floor1.global_transform.origin.x -= delta * speed
	floor2.global_transform.origin.x -= delta * speed
	
	if floor1.global_transform.origin.x <= -60:
		var sobra = floor1.global_transform.origin.x + 60
		floor1.global_transform.origin.x = respawn + sobra
	if floor2.global_transform.origin.x <= -60:
		var sobra = floor2.global_transform.origin.x + 60
		floor2.global_transform.origin.x = respawn + sobra
