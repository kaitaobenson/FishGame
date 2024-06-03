extends Node

"""
func top_down_movement():
	var A = 0
	var B = 0
	
	if Input.is_action_pressed("Left"):
		A = 1
	if Input.is_action_just_released("Left"):
		A = 0
	
	if Input.is_action_pressed("Right"):
		A = 2
	if Input.is_action_just_released("Right"):
		A = 0
	
	if Input.is_action_pressed("Up"):
		B = 4
	if Input.is_action_just_released("Up"):
		B = 0
	
	if Input.is_action_pressed("Down"):
		B = 8
	if Input.is_action_just_released("Down"):
		B = 0
	
	var list = [400, 180, 0, 400, 270, 225, 315, 270, 90, 135, 45, 90, 400]
	
	var angle = list[A+B]
	var speed = MOVEMENT_SPEED
	if angle == 400:
		speed = 0
	
	velocity = angle_to_speed(angle, speed)
	move_and_slide()
"""
