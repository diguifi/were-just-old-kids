extends MeshInstance3D

@onready var chao = $StaticBody3D

func _process(delta):
	if global_transform.origin.x < -5:
		queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group('player'):
		body.hurt()
		chao.global_transform.origin.y = 999
