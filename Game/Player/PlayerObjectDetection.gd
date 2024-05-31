extends Node2D

const DAMAGERS: Dictionary = {
	"Fish1" = 10
}

const INTERACTABLES: Array = [
	"Submarine"
	
]

@onready var hurtbox: Area2D = $"Hurtbox"
var hurtbox_overlapping_bodies: Array = []
var hurtbox_overlapping_areas: Array = []

@onready var interactable: Area2D = $"InteractArea"
var interact_overlapping_bodies: Array = []
var interact_overlapping_areas: Array = []


func _process(delta):
	hurtbox_overlapping_bodies = hurtbox.get_overlapping_bodies()
	hurtbox_overlapping_areas = hurtbox.get_overlapping_areas()
	
	interact_overlapping_bodies = interactable.get_overlapping_bodies()
	interact_overlapping_areas = interactable.get_overlapping_areas()
	
	
	### INTERACT ###
	if Input.is_action_just_pressed("Interact"):
		for i in INTERACTABLES.size():
			# See if overlapping bodies has interactables
			for j in interact_overlapping_bodies.size():
				var body = interact_overlapping_bodies[j]
				if body.has_method("get_object_name"):
					# If it does, call interact()
					if body.get_object_name() == INTERACTABLES[i] && body.has_method("interact"):
						body.interact()
	
	
