extends RigidBody2D
class_name Boat

@export var player_data : PlayerData
@export var arrow_scene : PackedScene

@export var arrow_container : Node2D
@export var ARROW_RADIUS := 128.0
var arrows : Array[Arrow] = []

@export var module_gifts : ModuleGifts
@export var module_visuals : ModuleVisuals
@export var ui : UI
@export var map_overlay : Node2D

const ARROW_NODE_DIRS := [Vector2i.RIGHT, Vector2(1,1), Vector2i.DOWN, Vector2i(-1,1), Vector2i.LEFT, Vector2i(-1,-1), Vector2i.UP, Vector2i(1,-1)]

signal moved(new_pos:Vector2)
signal finish_request()

func _ready() -> void:
	create_arrows()
	
	Global.input.buttons_changed.connect(_on_buttons_changed)
	module_gifts.gifts_changed.connect(ui._on_gifts_changed)
	moved.connect(ui._on_boat_moved)

func _physics_process(delta: float) -> void:
	apply_debug_input()
	apply_arrow_movement(delta)
	rotate_arrows(delta)
	keep_arrows_with_boat()
	moved.emit(global_position)

func apply_debug_input() -> void:
	if not OS.is_debug_build(): return
	var vec = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	move(vec * 100.0)

func rotate_arrows(delta: float) -> void:
	var num_players = player_data.count()
	var factor : float = lerp(Global.config.arrow_rotate_speed_factor.x, Global.config.arrow_rotate_speed_factor.y, num_players/8.0)
	var speed := Global.config.arrow_rotate_speed_base * factor
	arrow_container.rotate(speed * delta)

func keep_arrows_with_boat() -> void:
	arrow_container.global_position = self.global_position

func count_dirs() -> int:
	return Global.config.boat_dirs_high_player_count.size()

func create_arrows() -> void:
	var num := count_dirs()
	for i in range(num):
		var a : Node2D = arrow_scene.instantiate()
		arrow_container.add_child(a)
		arrows.append(a)
		a.set_visible(false)
		
		var dir : Vector2i = ARROW_NODE_DIRS[i]
		var pos := Vector2(dir).normalized() * ARROW_RADIUS
		a.set_position(pos)
		a.set_rotation(Vector2(dir).angle())
		
		a.dir = dir
		a.idx = i
	
	remove_child(arrow_container)
	map_overlay.add_child(arrow_container)
	keep_arrows_with_boat()

func _on_buttons_changed():
	var num_players := player_data.count()
	if num_players <= 0: return
	
	# wait to make sure the player's buttons have all updated
	# @TODO: find cleaner way for this
	await get_tree().process_frame
	
	var players := player_data.players
	var dirs_possible := Global.config.boat_dirs_high_player_count
	if num_players <= 4: dirs_possible = Global.config.boat_dirs_low_player_count 
	if num_players <= 2: dirs_possible = Global.config.boat_dirs_two_player_count
	var cur_player_idx := 0
	
	for arrow in arrows:
		arrow.set_visible(false)
	
	for player in players:
		player.clear_connected_arrows()
	
	for dir in dirs_possible:
		var player := players[cur_player_idx]
		player.add_connected_arrow(arrows[convert_dir_to_arrow_index(dir)])
		cur_player_idx = (cur_player_idx + 1) % num_players

func apply_arrow_movement(delta) -> void:
	var move_vec := Vector2()
	for arrow in arrows:
		move_vec += arrow.get_vector().rotated(arrow_container.rotation)
	move(move_vec)

func move(vec: Vector2) -> void:
	apply_central_impulse(vec)

func convert_dir_to_arrow_index(dir:Vector2i) -> int:
	var num_dirs := count_dirs()
	var angle := Vector2(dir).angle() + 2*PI # make sure all positive
	var idx : int = int(round(angle / (2*PI) * num_dirs)) % num_dirs # convert to 0-7 on circle
	return idx

func convert_dirs_to_arrow_indices(dirs:Array[Vector2i]) -> Array[int]:
	var arr : Array[int] = []
	for dir in dirs:
		arr.append(convert_dir_to_arrow_index(dir))
	return arr

func finish() -> void:
	print("Should finish!")
	finish_request.emit()

func play_bounce_tween() -> void:
	var dur := 0.15
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(module_visuals, "scale", Vector2.ONE*1.2, 0.5*dur)
	tween.tween_property(module_visuals, "scale", Vector2.ONE, dur)
