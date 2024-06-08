extends Node3D

@export var chunks: Array[PackedScene]
@onready var end = $End
var rng = RandomNumberGenerator.new()
var last_chunk = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var chunk = chunks[2].instantiate()
	add_child(chunk)


func _on_area_3d_area_entered(area):
	if area.is_in_group("end"):
		var my_random_number = get_random_index()
		var chunk = chunks[my_random_number].instantiate()
		add_child(chunk)

func get_random_index():
	var selected_number = last_chunk
	while (selected_number == last_chunk):
		selected_number = rng.randi_range(0, chunks.size()-1)
	last_chunk = selected_number
	return selected_number
