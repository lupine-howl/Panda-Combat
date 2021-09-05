extends Camera2D

var target = null


func _physics_process(delta):
	if is_instance_valid(target):
		position = target.position
