extends Node

var world_speed = 5
var road_trip_head_rotation = Vector3(0,0,0)
var sprite_visible = false
var looking_at_gb = true
var time_looking_at_sprite = 0
var time_to_show_sprite = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	calculate_looking_at_sprite(delta)

func calculate_looking_at_sprite(delta):
	looking_at_gb = road_trip_head_rotation.y < -1.2 and road_trip_head_rotation.x < -0.1
	if !sprite_visible:
		if road_trip_head_rotation.y >= -0.3 and road_trip_head_rotation.x > -0.4 and road_trip_head_rotation.x < 0.14:
			time_looking_at_sprite+=delta
			if time_looking_at_sprite >= time_to_show_sprite:
				sprite_visible = true
		else:
			time_looking_at_sprite = 0
	
