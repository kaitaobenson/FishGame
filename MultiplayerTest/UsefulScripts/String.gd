extends ColorRect

@export var enabled: bool = true
@export var pos1_offset: Vector2 = Vector2(0,0)
@export var pos2_offset: Vector2 = Vector2(0,0)

var pos1: Vector2 = Vector2(0,0)
var pos2: Vector2 = Vector2(0,0)

var updated_pos1: Vector2
var updated_pos2: Vector2

func _physics_process(delta):
	if enabled:
		visible = true
	else:
		visible = false
	
	updated_pos1 = pos1 + pos1_offset
	updated_pos2 = pos2 + pos2_offset
	
	global_position = updated_pos1
	rotation = updated_pos1.angle_to_point(updated_pos2)
	scale.x = updated_pos1.distance_to(updated_pos2) / size.x
