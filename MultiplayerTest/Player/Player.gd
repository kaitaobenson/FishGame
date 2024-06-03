extends CharacterBody2D

const GRAVITY: int = 5
const WALK_SPEED: int = 300
const JUMP_FORCE: int = 300
const DOWN_FORCE: int = 100

enum TOOLS {
	GUN,
	FLASHLIGHT,
}

var current_tool: TOOLS = TOOLS.FLASHLIGHT


var oxygen_level: float = 100.0


#Is in submarine?
var can_move1: bool = true
#Empty
var can_move2: bool = true


var bullet = load("res://Bullet.tscn")

@onready var ray_up = $"GroundRaycasts/Up"
@onready var ray_down = $"GroundRaycasts/Down"
@onready var ray_left = $"GroundRaycasts/Left"
@onready var ray_right = $"GroundRaycasts/Right"

@onready var flashlight = $"Flashlight"
@onready var collision = $"Collision"

func _init():
	Global.player = self


func _physics_process(delta):
	### Movement ###
	if can_move1 && can_move2:
		do_move()
		do_gravity()
		move_and_slide()
	
	### Switch to different tools ###
	if Input.is_action_just_pressed("1"):
		current_tool = TOOLS.FLASHLIGHT
	if Input.is_action_just_pressed("2"):
		current_tool = TOOLS.GUN
	
	
	### Use different tools ###
	if current_tool == TOOLS.FLASHLIGHT:
		do_flashlight()
	else:
		flashlight.visible = false
		
	if current_tool == TOOLS.GUN:
		do_shoot()
	
	
	### Update oxygen bar ###
	if oxygen_level > 100:
		oxygen_level = 100
	if oxygen_level < 0:
		oxygen_level = 0
	Global.ui.get_node("ProgressBar").value = oxygen_level


func do_move():
	if Input.is_action_just_pressed("Dash"):
		### Dash movement ###
		var angle_to_mouse = rad_to_deg(position.angle_to_point(get_global_mouse_position()))
		velocity = angle_to_speed(angle_to_mouse, 2000)
		
	else:
		### WASD movement ###
		if Input.is_action_pressed("Left"):
			velocity.x = -WALK_SPEED
		if Input.is_action_pressed("Right"):
			velocity.x = WALK_SPEED
		
		if Input.is_action_just_pressed("Up"):
			velocity.y = -JUMP_FORCE
		if Input.is_action_just_pressed("Down"):
			velocity.y = DOWN_FORCE


func do_gravity():
	velocity.y += GRAVITY
	
	velocity.x = lerp(velocity.x, 0.0, 0.1)


func do_shoot():
	if Input.is_action_just_pressed("Shoot"):
		var new_bullet = bullet.instantiate()
		var angle = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
		
		new_bullet.angle = angle
		new_bullet.position = angle_to_position(position, angle, 30)
		
		add_sibling(new_bullet)


func do_flashlight():
	flashlight.visible = true
	flashlight.rotation_degrees = rad_to_deg(position.angle_to_point(get_global_mouse_position())) + 45



### FOR OTHER NODES ###

#Turns collision off/on
func set_enabled(enabled: bool) -> void:
	collision.disabled = !enabled

#Oxygen
func set_oxygen_level(amount: float) -> void:
	oxygen_level = amount
func get_oxygen_level() -> float:
	return oxygen_level


### HELPER METHODS ###

#Takes angle and speed, returns into x vel and y vel
func angle_to_speed(angle: float, speed: float) -> Vector2:
	angle = fmod(fmod(angle, 360) + 360, 360)
	
	var x_vel = speed * cos(deg_to_rad(angle))
	var y_vel = speed * sin(deg_to_rad(angle))
	
	return Vector2(x_vel, y_vel)

#Takes position, and an angle and dist away from that point, returns x pos and y pos
func angle_to_position(pos: Vector2, angle: float, dist: float) -> Vector2:
	angle = fmod(fmod(angle, 360) + 360, 360)
	
	var x_pos = pos.x + dist * cos(deg_to_rad(angle))
	var y_pos = pos.y + dist * sin(deg_to_rad(angle))
	
	return Vector2(x_pos, y_pos)
