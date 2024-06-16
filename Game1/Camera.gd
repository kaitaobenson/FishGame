extends Camera2D


func _init():
	Global.camera = self


func _ready():
	pass
	
	# Out of bounds later


func _process(delta):
	position = lerp(position, Global.player.position, 0.1)

