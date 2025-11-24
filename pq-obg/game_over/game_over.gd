class_name GameOver extends Node2D

@export var state_data : StateData
@export var result_list_scene : PackedScene
var state := GameOverState.MATCH_RANK
var result_list : GameResultList

@onready var rankings_container : Control = $Rankings/Container/CenterContainer/VBoxContainer/ScrollContainer/MarginContainer
@onready var forward_btn : Button = $Rankings/Container/CenterContainer/VBoxContainer/HBoxContainer/Forward
@onready var table_heading : Label = $Rankings/Container/CenterContainer/VBoxContainer/TableHeading

enum GameOverState
{
	MATCH_RANK,
	GAME_RANK
}

func _ready() -> void:
	state_data.debug_set_to_gameover()
	state_data.make_temporary_results_permanent()
	forward_btn.set_text("Continue")
	forward_btn.grab_focus()
	table_heading.set_text("Match Results")
	state = GameOverState.MATCH_RANK
	show_results()

func show_results() -> void:
	if result_list: result_list.queue_free()
	result_list = result_list_scene.instantiate()
	rankings_container.add_child(result_list)
	
	var tracker_data := state_data.tracker_temporary if (state == GameOverState.MATCH_RANK) else state_data.tracker_permanent
	result_list.show_tracker(tracker_data)

func _unhandled_input(_ev:InputEvent) -> void:
	return
	#if ev.is_action_released("ui_backward"):
		#_on_backward_pressed()
	#
	#if ev.is_action_released("ui_forward"):
		#_on_forward_pressed()

func _on_backward_pressed() -> void:
	get_tree().change_scene_to_file("res://pq-obg/menu/menu.tscn")

func _on_forward_pressed() -> void:
	if state == GameOverState.GAME_RANK:
		get_tree().change_scene_to_file("res://" + Global.config_shared.game_id + "/main.tscn")
	
	if state == GameOverState.MATCH_RANK:
		state = GameOverState.GAME_RANK
		forward_btn.set_text("Play Again")
		table_heading.set_text("Game Results")
		show_results()
