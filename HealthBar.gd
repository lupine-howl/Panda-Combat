extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var health
var max_health

func set_health(_health, _max_health):
	health = _health
	max_health = _max_health
	update()
	pass

func _draw():
	draw_rect(Rect2(position.x, position.y, max_health*4, 3), Color.red)
	draw_rect(Rect2(position.x, position.y, health*4, 3), Color.green)
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
