extends Node

var level = 0
var world_speed = 5
var road_trip_head_rotation = Vector3(0,0,0)
var sprite_visible = false
var looking_at_gb = true
var looking_at_city = false
var alcancou_vista = false
var goal

func calculate_looking_at_forest():
	return (level == 1) and (Globals.road_trip_head_rotation.y >= -0.3 and Globals.road_trip_head_rotation.x > -0.4 and Globals.road_trip_head_rotation.x < 0.14)

func calculate_looking_at_city():
	print(Globals.road_trip_head_rotation)
	return (level == 2) and (Globals.alcancou_vista and (Globals.road_trip_head_rotation.y >= 0.3 and Globals.road_trip_head_rotation.y < 1.4 and Globals.road_trip_head_rotation.x > -0.5 and Globals.road_trip_head_rotation.x < 0.5))
