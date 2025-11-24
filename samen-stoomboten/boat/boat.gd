extends RigidBody2D
class_name Boat

@export var player_data : PlayerData
@export var arrow_scene : PackedScene

@export var arrow_container : Node2D
@export var ARROW_RADIUS := 128.0
var arrows : Array[Node2D] = []

@export var module_gifts : ModuleGifts
@export var ui : UI

const ARROW_ROTATE_SPEED := 0.25
const NUM_DIRS := 8
const DIRS_LOW_PLAYER_COUNT : Array[Vector2i] = [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP]
const DIRS_HIGH_PLAYER_COUNT : Array[Vector2i] = [Vector2i.RIGHT, Vector2i.LEFT, Vector2i.DOWN, Vector2i.UP, Vector2i(1,1), Vector2i(-1,-1), Vector2i(-1,1), Vector2i(1,-1)]

@export var debug_input := false

signal moved(new_pos:Vector2)

func _ready() -> void:
	Global.input.buttons_changed.connect(_on_buttons_changed)
	
	create_arrows()
	
	print(Global.input.get_next_button_any().print_pretty())
	
	module_gifts.gifts_changed.connect(ui._on_gifts_changed)
	moved.connect(ui._on_boat_moved)

func _physics_process(delta: float) -> void:
	apply_debug_input()
	apply_arrow_movement(delta)
	rotate_arrows(delta)
	moved.emit(global_position)

func apply_debug_input() -> void:
	if not debug_input: return
	var vec = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	move(vec * 100.0)

func rotate_arrows(delta: float) -> void:
	arrow_container.rotate(ARROW_ROTATE_SPEED * delta)

func create_arrows() -> void:
	for i in range(NUM_DIRS):
		var a : Node2D = arrow_scene.instantiate()
		arrow_container.add_child(a)
		arrows.append(a)
		
		var angle := 2 * PI * (i/float(NUM_DIRS))
		var dir := Vector2.from_angle(angle)
		var pos := dir * ARROW_RADIUS
		a.set_position(pos)
		a.set_rotation(angle)
		
		a.dir = dir
		a.idx = i

func _on_buttons_changed():
	var num_players := player_data.count()
	if num_players <= 0: return
	
	# wait to make sure the player's buttons have all updated
	# @TODO: find cleaner way for this
	await get_tree().process_frame
	
	var players := player_data.players
	var dirs_possible := DIRS_LOW_PLAYER_COUNT if num_players <= 4 else DIRS_HIGH_PLAYER_COUNT
	var cur_player_idx := 0
	
	for arrow in arrows:
		arrow.set_visible(false)
	
	for player in players:
		player.clear_connected_arrows()
	
	for dir in dirs_possible:
		var player := players[cur_player_idx]
		player.add_connected_arrow(arrows[convert_dir_to_arrow_index(dir)])
		cur_player_idx = (cur_player_idx + 1) % num_players
	
	print("#players: " + str(players))

func apply_arrow_movement(delta) -> void:
	var move_vec := Vector2()
	for arrow in arrows:
		move_vec += arrow.get_vector().rotated(arrow_container.rotation)
	
	print("Calculated final movement vector: r" + str(move_vec))
	move(move_vec)

func move(vec: Vector2) -> void:
	apply_central_impulse(vec)

func convert_dir_to_arrow_index(dir:Vector2i) -> int:
	var angle := Vector2(dir).angle() + 2*PI # make sure all positive
	var idx : int = int(round(angle / (2*PI) * NUM_DIRS)) % NUM_DIRS # convert to 0-7 on circle
	return idx

func convert_dirs_to_arrow_indices(dirs:Array[Vector2i]) -> Array[int]:
	var arr : Array[int] = []
	for dir in dirs:
		arr.append(convert_dir_to_arrow_index(dir))
	return arr

func finish() -> void:
	print("Should finish!")
	pass
