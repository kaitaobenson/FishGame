extends Camera2D


func _init():
	Global.camera = self


func _ready():
	limit_top = $"../OutOfBounds/Up".position.y
	limit_bottom = $"../OutOfBounds/Down".position.y
	limit_left = $"../OutOfBounds/Left".position.x
	limit_right = $"../OutOfBounds/Right".position.x


func _process(delta):
	position = lerp(position, Global.player.position, 0.03)

