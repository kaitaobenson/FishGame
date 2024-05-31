extends CharacterBody2D

const OBJECT_NAME: String = "Submarine"
const LEFT_RIGHT_SPEED: int = 600
const UP_DOWN_SPEED: int = 300

#Collision shape must be circle!
@onready var oxygen_radius = $"OxygenArea/CollisionShape2D".shape.radius
@onready var string = $"String"

var is_in_submarine: bool = false
var once: bool = false

func _process(delta):
	if is_in_submarine:
		Global.player.can_move1 = false
		Global.player.set_enabled(false)
		
		once = true
		Global.player.position = position
		
		if Input.is_action_pressed("Left"):
			velocity.x = -LEFT_RIGHT_SPEED
		if Input.is_action_pressed("Right"):
			velocity.x = LEFT_RIGHT_SPEED
		
		if Input.is_action_pressed("Up"):
			velocity.y = -UP_DOWN_SPEED
		if Input.is_action_pressed("Down"):
			velocity.y = UP_DOWN_SPEED
		
		do_gravity()
		move_and_slide()
		
	else:
		Global.player.can_move1 = true
		if once:
			Global.player.set_enabled(true)
			once = false
	
	string.pos1 = global_position
	string.pos2 = Global.player.global_position
	
	if position.distance_to(Global.player.position) < oxygen_radius:
		Global.player.set_oxygen_level(Global.player.get_oxygen_level() + 0.07)
		string.enabled = true
	else:
		Global.player.set_oxygen_level(Global.player.get_oxygen_level() - 0.07)
		string.enabled = false


func do_gravity():
	velocity.x = lerp(velocity.x, 0.0, 0.1)
	velocity.y = lerp(velocity.y, 0.0, 0.1)


func interact():
	is_in_submarine = !is_in_submarine

func get_object_name() -> String:
	return OBJECT_NAME
