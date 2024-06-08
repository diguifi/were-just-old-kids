extends Node2D

@onready var sprite = $Sprite2D
var speed = 6
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var chance = rng.randi_range(0,100)
	if chance < 50:
		sprite.frame = 4
	else:
		sprite.frame = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Globals.looking_at_gb:
		transform.origin.x -= speed


func _on_area_2d_area_entered(area):
	if area.name == 'PlayerArea':
		area.get_parent().get_parent().hurt()
	if area.name == 'PointsArea':
		area.get_parent().get_parent().add_points()
