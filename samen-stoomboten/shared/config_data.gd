extends Resource
class_name ConfigData

@export var settings : Array[SettingTab] = []
@export var tutorials : Array[TutorialStage] = []

@export_group("Boat")
@export_subgroup("Arrows")
@export var arrow_rotate_speed_base := 0.25 
@export var arrow_rotate_speed_factor := Vector2(3.0, 0.4) # modifies it based on player count
@export var boat_dirs_two_player_count := [Vector2i.RIGHT, Vector2i.DOWN]
@export var boat_dirs_low_player_count := [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]
@export var boat_dirs_high_player_count := [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP, Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]

@export_subgroup("Movement")
@export var boat_player_speed := 200.0

@export_group("Map")
@export var min_dist_between_objects := 256.0
@export var world_edge_margin := 256.0

@export_subgroup("Chunks")
@export var map_num_chunks := 8
@export var map_chunk_size := Vector2(1000, 2000)

@export_subgroup("Gifts")
@export var num_gifts := 20
@export var gift_eject_radius := 256.0
@export var gift_float_speed := 10.0
@export var gift_float_radius := 256.0

@export_subgroup("Obstacles")
@export var num_obstacles := 20
@export var obstacle_hit_damage_multiplier := 0.01
