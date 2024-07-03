extends TileMap

const TileLightPath = preload("res://tile_light.tscn")
const max_light_energy = 10.0

@onready var player = $"../../Player"
@onready var light_polygon = $"../../Player/Flashlight/Area2D/CollisionPolygon2D"

var greatest_distance : float


# Called when the node enters the scene tree for the first time.
func _ready():
	for point in light_polygon.polygon:
		if point.distance_to(Vector2(0,0)) > greatest_distance:
			greatest_distance = point.distance_to(Vector2(0,0))
	
	for cell in get_used_cells(0):
		var light = TileLightPath.instantiate()
		add_child(light)
		light.global_position.x = (cell.x + .5) * tile_set.tile_size.x
		light.global_position.y = (cell.y + .5) * tile_set.tile_size.y
		light.z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tile_lighting()

func tile_lighting():
	#This all is just to get it to account for rotation and stuff
	var polygon_points_global : PackedVector2Array
	
	for point in light_polygon.polygon:
		var global_point = light_polygon.global_position + point.rotated(light_polygon.global_rotation)
		polygon_points_global.append(global_point)
	
	for child in get_children():
		if child is PointLight2D:
			var charging_intensity : float = child.global_position.distance_to(player.global_position) / greatest_distance * .01
			
			#All of the stuff with corners is so it checks if all of the corners of the shape are in rather than the center
			var tile_size = tile_set.tile_size
			var tile : Vector2
			var corners_of_cell : PackedVector2Array
			var corner_is_in : bool = false
			
			tile.x = child.global_position.x - tile_size.x * .5
			tile.y = child.global_position.y - tile_size.y * .5
			
			corners_of_cell.append(tile)
			corners_of_cell.append(Vector2(tile.x + tile_size.x, tile.y))
			corners_of_cell.append(Vector2(tile.x + tile_size.x, tile.y + tile_size.y))
			corners_of_cell.append(Vector2(tile.x, tile.y + tile_size.y))
			
			for corner in corners_of_cell:
				if !corner_is_in:
					if Geometry2D.is_point_in_polygon(corner, polygon_points_global):
						corner_is_in = true
			
			if corner_is_in:
				child.energy = lerp(child.energy, max_light_energy, charging_intensity)
				#print("sigma")
			else:
				child.energy = lerp(child.energy, 0.0, .005)


func generate_connections(points):
	#Thingy i stole from copilot
	#I should stop stealing things from copilot
	#But most of my work is my own
	#I swear
	var connections = PackedInt32Array()
	for i in range(points.size() - 1):
		connections.append_array([i, i + 1])
	connections.append_array([points.size() - 1, 0])
	return connections
