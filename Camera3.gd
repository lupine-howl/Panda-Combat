extends Camera2D

var target1 = null
var target2 = null

#func _physics_process(delta):
	#if (target1&&target2):
		#position = (target1.position + target2.position) / 2
