extends Node2D
class_name Map

@export var gift_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var finish_scene : PackedScene

@export var map_data : MapData
@export var boat : Boat
@export var ui : UI

var chunk_size : Vector2
var world_size : Vector2
var all_nodes : Array[Node2D] = []

var time_start := 0.0

func _ready() -> void:
	map_data.reset(boat)
	boat.finish_request.connect(_on_boat_finished)
	time_start = Time.get_ticks_msec()
	generate()

func _on_boat_finished():
	var time_end := Time.get_ticks_msec()
	map_data.time = (time_end - time_start) / 1000.0
	map_data.obstacles_hit = boat.module_collider.num_hits
	ui.goto_game_over()

func get_random_valid_position(rect:Rect2, avoid:Array[Node2D]) -> Vector2:
	var max_tries := 200
	var pos:Vector2
	var min_dist := Global.config.min_dist_between_objects
	for i in range(max_tries):
		pos = get_random_position_in_rect(rect)
		
		var bad_pos := false
		for node in avoid:
			var dist = pos.distance_to(node.position)
			if dist > min_dist: continue
			bad_pos = true
			break
		
		if bad_pos: continue
		return pos
	return pos

func get_random_position_in_rect(rect:Rect2) -> Vector2:
	return rect.position + Vector2(randf(), randf())*rect.size

func generate() -> void:
	var num_chunks := Global.config.map_num_chunks
	var num_gifts := Global.config.num_gifts
	var num_obstacles := Global.config.num_obstacles
	chunk_size = Global.config.map_chunk_size
	world_size = Vector2(num_chunks * chunk_size.x, chunk_size.y)
	
	# prepare gift types for balanced distribution
	var num_books = max(floor(Global.config.mapgen_add_book_perc * num_chunks), 1)
	if not Global.config.mapgen_add_books: num_books = 0
	
	var num_candy = max(floor(Global.config.mapgen_add_candy_perc * num_chunks), 1)
	if not Global.config.mapgen_add_candy: num_candy = 0
	
	var gift_types : Array[Gift.GiftType] = []
	for i in range(num_books):
		gift_types.append(Gift.GiftType.BOOK)
	for i in range(num_candy):
		gift_types.append(Gift.GiftType.CANDY)
	while gift_types.size() < num_gifts:
		gift_types.append(Gift.GiftType.GIFT)
	gift_types.shuffle()
	
	# place stuff in the water
	var gifts_per_chunk = round(num_gifts / float(num_chunks))
	var obstacles_per_chunk = round(num_obstacles / float(num_chunks))
	
	for i in range(num_chunks):
		var rect := Rect2(i*Vector2(chunk_size.x, 0), chunk_size)
		
		for g in range(gifts_per_chunk):
			place_gift(rect, gift_types.pop_back())
		
		for o in range(obstacles_per_chunk):
			place_obstacle(rect)
	
	ui.update_total_gifts(map_data.gifts.size())
	
	var edge_margin := Global.config.world_edge_margin
	
	# place finish
	var finish = finish_scene.instantiate()
	finish.set_position(Vector2(world_size.x, 0.5*world_size.y))
	add_child(finish)
	finish.resize_to(chunk_size + 2*Vector2(edge_margin, edge_margin))
	
	# place guard rails at edges
	var world_boundary_body = StaticBody2D.new()
	add_child(world_boundary_body)
	
	var right_edge_world := Vector2(world_size.x + edge_margin, 0)
	var bottom_edge_world := Vector2(0, world_size.y + edge_margin)
	var positions := [Vector2(-edge_margin, 0), right_edge_world, Vector2(0, -edge_margin), bottom_edge_world]
	var normals := [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	for i in range(4):
		var shape_node = CollisionShape2D.new()
		shape_node.set_position(positions[i])
		var shape = WorldBoundaryShape2D.new()
		shape.normal = normals[i]
		shape_node.shape = shape
		world_boundary_body.add_child(shape_node)

func place_gift(rect:Rect2, tp:Gift.GiftType) -> void:
	var gift := gift_scene.instantiate()
	gift.set_position(get_random_valid_position(rect, all_nodes))
	add_child(gift)
	all_nodes.append(gift)
	map_data.gifts.append(gift)
	gift.set_type(tp)

func place_obstacle(rect:Rect2) -> void:
	var obs := obstacle_scene.instantiate()
	obs.set_position(get_random_valid_position(rect, all_nodes))
	add_child(obs)
	all_nodes.append(obs)
	map_data.obstacles.append(obs)

func get_x_ratio(x_dist:float) -> float:
	return clamp(x_dist / world_size.x, 0.0, 1.0)
