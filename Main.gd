extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var viewport1 = $Viewports/ViewportContainer1/Viewport1
onready var viewport2 = $Viewports/ViewportContainer2/Viewport2
onready var minimap = $Minimap/Viewport
var panda = preload("res://characters/Panda.tscn")
var minotaur = preload("res://characters/Minotaur.tscn")
var squire = preload("res://characters/Squire.tscn")
var world
var levels = ["Level1", "Level2", "Level3"]
var current_level = 0
onready var cameras = [$Viewports/ViewportContainer1/Viewport1/Camera1, $Viewports/ViewportContainer2/Viewport2/Camera2]
onready var minimap_camera = $Minimap/Viewport/Camera3

var player_characters = [[],[]]
var current_player_character = [-1,-1]

func handle_controls():
	if(Input.is_action_just_pressed("ui_left")):
		player(0).intentions.push_back("walk_left")
	if(Input.is_action_just_released("ui_left")):
		player(0).intentions.erase("walk_left")
		
	if(Input.is_action_just_pressed("ui_right")):
		player(0).intentions.push_back("walk_right")
	if(Input.is_action_just_released("ui_right")):
		player(0).intentions.erase("walk_right")
		
	if(Input.is_action_just_pressed("ui_up")):
		player(0).intentions.push_back("walk_up")
	if(Input.is_action_just_released("ui_up")):
		player(0).intentions.erase("walk_up")
		
	if(Input.is_action_just_pressed("ui_down")):
		player(0).intentions.push_back("walk_down")
	if(Input.is_action_just_released("ui_down")):
		player(0).intentions.erase("walk_down")
				
	if(Input.is_action_just_pressed("ui_accept")):
		player(0).intentions.push_back("shoot")
		
	if(Input.is_action_just_pressed("ui_left_2")):
		player(1).intentions.push_back("walk_left")
	if(Input.is_action_just_released("ui_left_2")):
		player(1).intentions.erase("walk_left")
		
	if(Input.is_action_just_pressed("ui_right_2")):
		player(1).intentions.push_back("walk_right")
	if(Input.is_action_just_released("ui_right_2")):
		player(1).intentions.erase("walk_right")
		
	if(Input.is_action_just_pressed("ui_up_2")):
		player(1).intentions.push_back("walk_up")
	if(Input.is_action_just_released("ui_up_2")):
		player(1).intentions.erase("walk_up")
		
	if(Input.is_action_just_pressed("ui_down_2")):
		player(1).intentions.push_back("walk_down")
	if(Input.is_action_just_released("ui_down_2")):
		player(1).intentions.erase("walk_down")
				
	if(Input.is_action_just_pressed("ui_accept_2")):
		player(1).intentions.push_back("shoot")

	pass

func player(id):
	return player_characters[id][current_player_character[id]]
	pass

func set_camera_limits():
	var map_limits = world.get_used_rect()
	var map_cellsize = world.cell_size
	for cam in cameras:
		cam.limit_left = map_limits.position.x * map_cellsize.x
		cam.limit_down = map_limits.end.x * map_cellsize.x
		cam.limit_top = map_limits.position.y * map_cellsize.y
		cam.limit_bottom = map_limits.end.y * map_cellsize.y
			
func select_next_player_character(id):
	player(id).possessed = false
	player(id).intentions.clear()
	current_player_character[id] = current_player_character[id] + 1
	if(current_player_character[id] >= player_characters[id].size()):
		current_player_character[id] = 0
	cameras[id].target = player(id)
	player(id).intentions.clear()
	player(id).possessed = true
	pass

func select_prev_player_character(id):
	player(id).possessed = false
	player(id).intentions.clear()
	current_player_character[id] = current_player_character[id] - 1
	if(current_player_character[id] < 0):
		current_player_character[id] = player_characters[id].size()-1
	cameras[id].target = player(id)
	player(id).intentions.clear()
	player(id).possessed = true
	pass
	
func next_level():
	current_level = current_level + 1
	set_level(current_level)
	
func set_level(level_num):
	var level = load("res://levels/"+levels[level_num]+".tscn").instance()
	var start = level.find_node("Start")
	var character_node = level.find_node("PlayerCharacters")
	var i = 0
	for player in player_characters:
		for character in player:
			character.position = start.position
			character.start_position = start.position
			character.position.x = character.position.x + (50 * i)
			if(world):
				var old_character_node = world.find_node("PlayerCharacters")
				if(old_character_node):
					old_character_node.remove_child(character)
			character_node.add_child(character)
			character.set_owner(character_node)
			i = i + 1
			
	if(world):
		#world.hide()
		world.queue_free()
	world = level
	viewport1.add_child(world)
	viewport2.world_2d = viewport1.world_2d
	minimap.world_2d = viewport1.world_2d
			

# Called when the node enters the scene tree for the first time.
func _ready():
	player_characters[0].push_back(panda.instance())
	player_characters[0].push_back(panda.instance())
	player_characters[1].push_back(squire.instance())
	player_characters[1].push_back(squire.instance())
	set_level(0)
	select_next_player_character(0)
	select_next_player_character(1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_action_just_pressed("ui_next")):
		select_next_player_character(0)
	if(Input.is_action_just_pressed("ui_prev")):
		select_prev_player_character(0)
	if(Input.is_action_just_pressed("ui_next_2")):
		select_next_player_character(1)
	if(Input.is_action_just_pressed("ui_prev_2")):
		select_prev_player_character(1)
	handle_controls()
	pass


func _on_StateCheckTimer_timeout():
	var all_characters_safe = true
	for characters in player_characters:
		for character in characters:
			all_characters_safe = all_characters_safe && character.safe
			
	yield(get_tree().create_timer(1.5), "timeout")		
	if(all_characters_safe):
		next_level()
	else:
		if player(0).safe:
			select_next_player_character(0)
		if player(1).safe:
			select_next_player_character(1)
		
	pass # Replace with function body.
