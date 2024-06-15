extends Node2D

const SPEED = 30
const SUBMARINE_LAYER_MASK = 1 << 2

@onready var area = $"Area2D"
var angle

func _ready():
	await get_tree().create_timer(10).timeout
	queue_free()

func _process(delta):
	if area.has_overlapping_bodies():
		var health_component = area.get_overlapping_bodies()[0].get_node("HealthComponent")
		if health_component != null:
			var attack = Attack.new()
			attack.attack_damage = 10
			health_component.damage(attack)
		queue_free()
	
	position += angle_to_speed(angle, SPEED)


### HELPER METHODS ###

func angle_to_speed(angle: float, speed: float) -> Vector2:
	#Takes angle and speed, returns into x vel and y vel
	angle = fmod(fmod(angle, 360) + 360, 360)
	
	var x_vel = speed * cos(deg_to_rad(angle))
	var y_vel = speed * sin(deg_to_rad(angle))
	
	return Vector2(x_vel, y_vel)
