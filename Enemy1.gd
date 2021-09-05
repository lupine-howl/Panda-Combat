extends Actor

var eval_period = 0.5
var shoot_period = 1
var eval_period_countdown = 1
var shoot_period_countdown = 1
	
func tick(delta):
	if(possessed):
		return
	eval_period_countdown = eval_period_countdown - delta
	shoot_period_countdown = shoot_period_countdown - delta
	if(eval_period_countdown <= 0):
		eval_period_countdown = eval_period
		evaluate_intentions()
	if(shoot_period_countdown <= 0):
		shoot_period_countdown = shoot_period
		evaluate_shot()
	pass

func evaluate_intentions():
	intentions.clear()
	if(target && (target.dead  || target.safe)):
		target = null
	if(!target):
		return
	if(target.position.x < position.x-10):
		intentions.push_back("walk_left")
	elif(target.position.x > position.x+10):
		intentions.push_back("walk_right")
	if(target.position.y < position.y-10):
		intentions.push_back("walk_up")
	elif(target.position.y > position.y+10):
		intentions.push_back("walk_down")
	pass # Replace with function body.


func evaluate_shot():
	if(target):
		intentions.push_back("shoot")
	pass # Replace with function body.


func _on_Sight_body_entered(body):
	if(!body):
		return
	var type = body.get_meta("type")
	if(type=="actor" && body!=self):
		target = body
	pass # Replace with function body.
