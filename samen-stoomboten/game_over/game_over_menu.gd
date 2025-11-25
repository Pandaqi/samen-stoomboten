extends Control
class_name GameOverMenu

@export var label_explanation : Label
@export var map_data : MapData
@export var forward_btn : Button
@export var anim_player : AnimationPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_visible(false)

func activate():
	set_visible(true)
	
	var num_gifts_total := map_data.gifts.size()
	var num_gifts_collected := map_data.gifts_collected.size()
	
	var text := "{num_col} {tr_1}! {tr_2} {num_total}.\n\n{tr_3} {num_hits} {tr_33}. {tr_4} {time} {tr_5}.".format({ num_col = num_gifts_collected, tr_1 = tr("GAME_OVER_GIFTS"), num_total = num_gifts_total, tr_2 = tr("GAME_OVER_TOTAL_GIFTS"), tr_3 = tr("GAME_OVER_OBSTACLE_HITS"), num_hits = map_data.obstacles_hit, tr_33 = tr("GAME_OVER_OBSTACLE_TYPE"), tr_4 = tr("GAME_OVER_TIME_SPENT"), time = floor(map_data.time), tr_5 = tr("GAME_OVER_TIME_UNIT") })
	label_explanation.text = text

	anim_player.play("go_fade")
	
	await anim_player.animation_finished
	
	get_tree().paused = true
	forward_btn.grab_focus()

func _on_backward_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://pq-obg/game_loop/menu/menu.tscn")

func _on_forward_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
