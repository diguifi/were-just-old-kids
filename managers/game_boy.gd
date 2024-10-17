extends MeshInstance3D

@onready var animation = $AnimationPlayer
var proximo = false
var battery_duration = 30
var current_battery = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_battery(delta)
	if Globals.looking_at_gb:
		approximate_gb()
	else:
		retract_gb()
		
func approximate_gb():
	if !proximo:
		proximo = true
		animation.play("aproximar")

func retract_gb():
	if proximo:
		proximo = false
		animation.play_backwards("aproximar")

func handle_battery(delta):
	current_battery += delta
	Globals.low_battery = current_battery > battery_duration/2
	Globals.gb_off = current_battery > battery_duration
