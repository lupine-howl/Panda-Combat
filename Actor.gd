extends KinematicBody2D
class_name Actor

export var max_speed = 3
export var start_health = 5
var health

var velocity = Vector2()
var current_animation
var Bullet = preload("res://Bullet.tscn")
var type = "actor"
var dead = false
var safe = false
var possessed = false
var start_position
var target

var limit_left
var limit_right
var limit_top
var limit_bottom

var intentions = []
var state
var time = 0

func setup():
	pass
	
func tick(time):
	pass
	
func die():
	dead = true
	target = null
	intentions.clear()
	yield(get_tree().create_timer(1.5), "timeout")
	position.x = start_position.x
	position.y = start_position.y
	health = start_health
	dead = false
	$HealthBar.set_health(health, start_health)
	#get_tree().reload_current_scene()
	pass

func hit(bullet):
	if(dead):
		return
	health = health - 1
	$HealthBar.set_health(health, start_health)
	if(health<=0):
		die()
	if(bullet!=null):
		bullet.queue_free()
	pass

func set_world_limits():
	var world = get_parent()
	var map_limits = world.get_used_rect()
	var map_cellsize = world.cell_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y


# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = Vector2(position.x, position.y)
	health = start_health
	setup()
	set_meta("type","actor")
	$HealthBar.set_health(health, start_health)
	#set_world_limits()
	pass # Replace with function body.
	
func set_animation(new_animation):
	if(new_animation!=current_animation):
		current_animation = new_animation
		$Sprite.play(new_animation)
	pass

		
func shoot(position, speed):
	if(dead):
		return
	var b = Bullet.instance()
	b.start(position, speed)
	get_parent().add_child(b)
	b.set_shooter(self)
	intentions.erase("shoot")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var new_animation = "idle"
	time = time + delta
	tick(delta)
	#update_intentions(state)
	velocity = Vector2.ZERO
	if(intentions.has("walk_left")):
		velocity.x = -max_speed
		$Sprite.scale.x = -1
		new_animation = "walk_side"
	elif(intentions.has("walk_right")):
		velocity.x = max_speed
		$Sprite.scale.x = 1
		new_animation = "walk_side"
	if(intentions.has("walk_up")):
		velocity.y = -max_speed
		new_animation = "walk_back"
	elif(intentions.has("walk_down")):
		velocity.y = max_speed
		new_animation = "walk_forward"
	if(intentions.has("shoot")):
		shoot(position, velocity*2)
	
	set_animation(new_animation)
	if(!dead):
		move_and_slide(velocity*50)
	pass
