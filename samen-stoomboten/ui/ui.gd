extends CanvasLayer
class_name UI

@export var staff_container : Node2D
@export var gift_counter : Label
@export var gift_counter_total : Label
@export var progress_bar : TextureProgressBar
@export var map : Map

@export var boat_start_pos : Node2D
@export var boat_end_pos : Node2D
@export var boat : Node2D

@export var game_over_menu : GameOverMenu
@export var anim_player : AnimationPlayer

const UI_HEIGHT := 64.0

func _ready() -> void:
	get_tree().get_root().size_changed.connect(refresh)
	refresh()
	_on_gifts_changed(0)

func refresh() -> void:
	var vp := get_viewport().get_visible_rect().size
	var pos := Vector2(0.5 * vp.x, vp.y - UI_HEIGHT)
	staff_container.set_position(pos)

func update_total_gifts(num:int) -> void:
	gift_counter_total.set_text(str(num))

func _on_gifts_changed(num_gifts:int) -> void:
	gift_counter.set_text(str(num_gifts))
	anim_player.play("gifts_change")

func _on_boat_moved(pos:Vector2) -> void:
	var ratio = map.get_x_ratio(pos.x)
	progress_bar.value = 0.35 + ratio * (1.0-0.35)
	
	var boat_pos = lerp(boat_start_pos.position, boat_end_pos.position, ratio)
	boat.set_position(boat_pos)

func goto_game_over() -> void:
	game_over_menu.activate()
