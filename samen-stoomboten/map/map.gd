extends Node2D
class_name Map

@export var gift_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var finish_scene : PackedScene

const NUM_CHUNKS := 2
const CHUNK_SIZE := Vector2(1000, 2000)

const NUM_GIFTS := 20
const NUM_OBSTACLES := 20
const WORLD_EDGE_MARGIN := 256.0

func _ready() -> void:
	generate()

func get_random_position_in_rect(rect:Rect2) -> Vector2:
	return rect.position + Vector2(randf(), randf())*rect.size

func generate() -> void:
	# place stuff in the water
	var gifts_per_chunk = NUM_GIFTS / float(NUM_CHUNKS)
	var obstacles_per_chunk = NUM_OBSTACLES / float(NUM_CHUNKS)
	
	for i in range(NUM_CHUNKS):
		var rect := Rect2(i*Vector2(CHUNK_SIZE.x, 0), CHUNK_SIZE)
		
		for g in range(gifts_per_chunk):
			place_gift(rect)
		
		for o in range(obstacles_per_chunk):
			place_obstacle(rect)
	
	# place finish
	var finish = finish_scene.instantiate()
	finish.set_position(Vector2(NUM_CHUNKS * CHUNK_SIZE.x, 0.5*CHUNK_SIZE.y))
	add_child(finish)
	finish.resize_to(CHUNK_SIZE + 2*Vector2(WORLD_EDGE_MARGIN, WORLD_EDGE_MARGIN))
	
	# place guard rails at edges
	var world_boundary_body = StaticBody2D.new()
	add_child(world_boundary_body)
	
	var right_edge_world := Vector2(NUM_CHUNKS*CHUNK_SIZE.x + WORLD_EDGE_MARGIN, 0)
	var bottom_edge_world := Vector2(0, CHUNK_SIZE.y + WORLD_EDGE_MARGIN)
	var positions := [Vector2(-WORLD_EDGE_MARGIN, 0), right_edge_world, Vector2(0, -WORLD_EDGE_MARGIN), bottom_edge_world]
	var normals := [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	for i in range(4):
		var shape_node = CollisionShape2D.new()
		shape_node.set_position(positions[i])
		var shape = WorldBoundaryShape2D.new()
		shape.normal = normals[i]
		shape_node.shape = shape
		world_boundary_body.add_child(shape_node)

func place_gift(rect:Rect2) -> void:
	var gift := gift_scene.instantiate()
	gift.set_position(get_random_position_in_rect(rect))
	add_child(gift)

func place_obstacle(rect:Rect2) -> void:
	var obs := obstacle_scene.instantiate()
	obs.set_position(get_random_position_in_rect(rect))
	add_child(obs)

func get_x_ratio(x_dist:float) -> float:
	return clamp(x_dist / (NUM_CHUNKS * CHUNK_SIZE.x), 0.0, 1.0)
