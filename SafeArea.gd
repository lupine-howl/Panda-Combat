extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SafeArea_area_entered(area):
	if(area.name=="Sight"):
		return
	var body = area.get_parent()
	if(body):
		var type = body.get_meta("type")
		if(type=="actor"):
			body.safe = true
	pass


func _on_SafeArea_area_exited(area):
	if(area.name=="Sight"):
		return
	var body = area.get_parent()
	if(body):
		var type = body.get_meta("type")
		if(type=="actor"):
			body.safe = false
	pass # Replace with function body.
