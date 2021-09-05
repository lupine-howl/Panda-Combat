extends Node2D

var velocity = Vector2()
var shooter

func start(pos, dir):
	if(dir==Vector2.ZERO):
		dir = Vector2(0,6)
	velocity = dir
	position = pos+dir
	
func set_shooter(new_shooter):
	shooter = new_shooter
	pass

func _physics_process(delta):
	position += velocity
	#var collision = move_and_collide(velocity * delta)
	#if collision:
	#	velocity = velocity.bounce(collision.normal)
	#	if collision.collider.has_method("hit"):
	#		collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func handle_hit(body):
	if(!body):
		return
	var type = body.get_meta("type")
	if(type=="actor" && body!=shooter):
		#var flag = $body.flag
		#body.remove_child(flag)
		#shooter.add_child(flag)
		#shooter.set_owner(flag)		
		body.hit(self)
	pass

func _on_bullet_area_body_entered(body):
	#print(body.type)
	#handle_hit(body)
	pass # Replace with function body.


func _on_bullet_area_area_entered(area):
	if(area.name=="Sight"):
		return
	print(area.name)
	var body = area.get_parent()
	handle_hit(body)
		
