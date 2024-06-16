extends CharacterBody2D

# Constants
const GRAVITY = 3
const GRAVITY_MAX_SPEED = 50
const SWIM_UP_MAX_SPEED = 80
const WALK_SPEED = 10
const JUMP_FORCE = 7
const DOWN_FORCE = 8
const WATER_Y_AXIS_FRICTION_FORCE = 5

enum TOOLS {
	GUN,
	FLASHLIGHT,
}

var current_tool = TOOLS.FLASHLIGHT
var oxygen_level = 100

# Check if player is in submarine
var can_move1 = true

# Empty
var can_move2 = true

@onready var ray_up = $"GroundRaycasts/Up"
@onready var ray_down = $"GroundRaycasts/Down"
@onready var ray_left = $"GroundRaycasts/Left"
@onready var ray_right = $"GroundRaycasts/Right"
@onready var flashlight = $"Flashlight"
@onready var collision = $"CollisionShape2D"
@onready var bullet = preload("res://Bullet.tscn")

func _init():
	Global.player = self

func _physics_process(delta):
	# Movement
	if can_move1 && can_move2:
		handle_movement()
		handle_gravity()
		
		# Update physics system. After this no physics-related
		# functions/code should be called.
		move_and_slide()
	
	handle_tool_switching()
	
	# Use different tools
	if current_tool == TOOLS.FLASHLIGHT:
		handle_flashlight()
	else:
		flashlight.visible = false
		
	if current_tool == TOOLS.GUN:
		handle_shooting()
	
	# Update oxygen bar 
	handle_oxygen_meter()

### Switch between tools (later should be an inventory) ###
func handle_tool_switching():
	if Input.is_action_just_pressed("1"):
		current_tool = TOOLS.FLASHLIGHT
	if Input.is_action_just_pressed("2"):
		current_tool = TOOLS.GUN
		
func handle_oxygen_meter():
	if oxygen_level > 100:
		oxygen_level = 100
	if oxygen_level < 0:
		oxygen_level = 0
	Global.ui.get_node("ProgressBar").value = oxygen_level

func handle_movement():
	if Input.is_action_just_pressed("Dash"):
		# Dash movement
		var angle_to_mouse = rad_to_deg(position.angle_to_point(get_global_mouse_position()))
		velocity = angle_to_speed(angle_to_mouse, 2000)
		
	else:
		# WASD movement
		if Input.is_action_pressed("Left"):
			velocity.x -= WALK_SPEED
		if Input.is_action_pressed("Right"):
			velocity.x += WALK_SPEED
		if Input.is_action_pressed("Left") || Input.is_action_pressed("Right"):
			velocity.y = lerp(velocity.y, 0.0, 0.2)
		
		if Input.is_action_pressed("Up") && velocity.y > -SWIM_UP_MAX_SPEED:
			velocity.y -= JUMP_FORCE
		if Input.is_action_pressed("Down"):
			velocity.y += DOWN_FORCE

func handle_gravity():
	if velocity.y < GRAVITY_MAX_SPEED:
		velocity.y += GRAVITY
	else:
		velocity.y -= WATER_Y_AXIS_FRICTION_FORCE
	
	velocity.x = lerp(velocity.x, 0.0, 0.15)

func handle_shooting():
	if Input.is_action_just_pressed("Shoot"):
		var new_bullet = bullet.instantiate()
		var angle = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
		
		new_bullet.angle = angle
		new_bullet.position = angle_to_position(position, angle, 30)
		
		add_sibling(new_bullet)

func handle_flashlight():
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
	
	var x_vel = cos(deg_to_rad(angle))
	var y_vel = sin(deg_to_rad(angle))
	
	return Vector2(x_vel, y_vel) * speed

#Takes position, and an angle and dist away from that point, returns x pos and y pos
func angle_to_position(pos: Vector2, angle: float, dist: float) -> Vector2:
	angle = fmod(fmod(angle, 360) + 360, 360)
	
	var x_pos = pos.x + dist * cos(deg_to_rad(angle))
	var y_pos = pos.y + dist * sin(deg_to_rad(angle))
	
	return Vector2(x_pos, y_pos)
