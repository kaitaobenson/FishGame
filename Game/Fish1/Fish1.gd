extends CharacterBody2D

const speed = 300
const accel = 7

@onready var nav = $"NavigationAgent2D"


func _physics_process(delta):
	var direction = Vector3()
	print(nav.get_next_path_position())
	print(Global.player.position)
	nav.target_position = Global.player.position
	
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	rotation = position.angle_to_point(nav.target_position) + 0.5 * PI
	
	move_and_slide()


func die():
	queue_free()
