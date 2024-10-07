extends Marker3D

var positions = [
	Vector3(-115.4, 21.7, -60.5),
	Vector3(-111.7, 10.1, -88.5),
	Vector3(-77.4, 19.0, -88.5),
	Vector3(-77.4, 28.1, -131.1),
	Vector3(-15.7, 21.0, -151.7)
]
var current_pos_index = 1
var max_indexes = 4
var previous_goal

func _ready() -> void:
	previous_goal = positions[0]

func _process(delta: float) -> void:
	Globals.goal = self

func go_to_next_position():
	if current_pos_index < max_indexes:
		current_pos_index += 1
		position = positions[current_pos_index]
		previous_goal = positions[current_pos_index-1]
	else:
		get_tree().change_scene_to_file("res://end.tscn")

func reset():
	current_pos_index = 1
	position = positions[current_pos_index]
	previous_goal = positions[0]
