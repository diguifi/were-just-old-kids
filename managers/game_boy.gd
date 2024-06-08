extends MeshInstance3D

@onready var animation = $AnimationPlayer
var proximo = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
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
