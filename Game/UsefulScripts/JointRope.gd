extends Node2D

@export var length = 10
@export var segment_radius = 6
@export var rope_anchor: Node = self
@export var color: Color = Color("#FFFFFF")
@export var extra_sprite_size: float = 0.1
@export var segment_sprite: String
@export var sprite_size: float

var previous_segment: NodePath
var current_length: int

func _ready():
	previous_segment = str(rope_anchor.get_path())
	current_length = segment_radius
	
	for i in length:
		### ADD THE RIGID BODY ###
		var rigid_body = RigidBody2D.new()
		rigid_body.position.y += current_length
		rigid_body.set_collision_mask_value(1, false)
		add_child(rigid_body)
		
		### ADD THE COLLISION ###
		var collision = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		shape.radius = segment_radius
		collision.set_shape(shape)
		collision.disabled = true
		
		
		get_node(str(rigid_body.name)).add_child(collision)
		
		### ADD THE SPRITE ###
		var sprite = Sprite2D.new()
		sprite.texture = load(segment_sprite)
		sprite.modulate = color
		var size = segment_radius * 2 / sprite_size + extra_sprite_size
		sprite.scale = Vector2(size, size)
		get_node(str(rigid_body.name)).add_child(sprite)
		
		
		### ADD THE PIN JOINT ###
		var joint = PinJoint2D.new()
		joint.node_a = previous_segment
		joint.node_b = "../" + str(rigid_body.name)
		joint.position.y += current_length
		joint.bias = 0.9
		joint.softness = 0.1
		
		add_child(joint)
		
		previous_segment = joint.node_b
		current_length += segment_radius

