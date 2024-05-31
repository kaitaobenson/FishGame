extends Node2D


const grid_size: int = 32

# Bake navigation region from physics layer of TileMap and children:
@onready var nav_region: NavigationRegion2D = $NavigationRegion2D
@onready var tilemap: TileMap = $"TileMap"

@onready var top = Global.camera.limit_top
@onready var bottom = Global.camera.limit_bottom
@onready var left = Global.camera.limit_left
@onready var right = Global.camera.limit_right

var tilemap_points: Array
var mesh_source = NavigationMeshSourceGeometryData2D.new()

func _ready():
	area_around_world()
	remove_tilemap_area()
	
	#NavigationServer2D.bake_from_source_geometry_data(nav_region.navigation_polygon, mesh_source)
	NavigationServer2D.bake_from_source_geometry_data_async(nav_region.navigation_polygon, mesh_source)


func area_around_world():
	nav_region.navigation_polygon.source_geometry_mode = (
	NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	)
	nav_region.navigation_polygon.clear()
	
	mesh_source.add_traversable_outline(
		PackedVector2Array(
			[
				Vector2(left, top),
				Vector2(right, top),
				Vector2(right, bottom),
				Vector2(left, bottom),
			]
		)
	)


func remove_tilemap_area():
	### REMOVING AREAS WITH TILEMAP ###
	tilemap.global_position = Vector2(0,0)
	nav_region.global_position = Vector2(0,0)
	
	#Turn Vector2i into Vector2
	var raw = tilemap.get_used_cells(0)
	for i in raw.size():
		tilemap_points.append(raw[i] * 32)
	
	for i in tilemap_points.size():
		var pos: Vector2 = tilemap_points[i]
		
		var corner1 = Vector2(pos.x + 00, pos.y + 00)
		var corner2 = Vector2(pos.x + 32, pos.y + 00)
		var corner3 = Vector2(pos.x + 32, pos.y + 32)
		var corner4 = Vector2(pos.x + 00, pos.y + 32)
		
		var polygon = PackedVector2Array(
				[
					corner1,
					corner2,
					corner3,
					corner4
				]
			)
		
		mesh_source.add_obstruction_outline(polygon)


func spawn_point(pos: Vector2):
	var rect = ColorRect.new()
	add_child(rect)
	rect.size = Vector2(5,5)
	rect.global_position = pos
