extends Marker2D

@export var chunks: Array[PackedScene]
var rng = RandomNumberGenerator.new()
var passed_time = 0
var max_time = 2
	
func _process(delta):
	if Globals.looking_at_gb:
		passed_time += delta
		if passed_time >= max_time:
			passed_time = 0
			max_time = rng.randf_range(0.8, 2)
			spawn()

func spawn():
	var my_random_number = get_random_index()
	var chunk = chunks[my_random_number].instantiate()
	add_child(chunk)

func get_random_index():
	return rng.randi_range(0, chunks.size()-1)
