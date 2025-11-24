class_name State extends CanvasLayer

enum GameState
{
	PREGAME,
	GAME,
	POSTGAME
}

@export var state_data : StateData
@export var player_data : PlayerData

@export var start_game_immediately := false
@export var disable_removing_if_paused := false

@export var pause_menu : PauseMenu
@export var tutorial : Tutorial

var paused := false
var state := GameState.PREGAME

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	state_data.reset()
	state_data.objective_registered.connect(on_objective_registered)
	Global.input.open_to_input = true
	
	pause_menu.forward_pressed.connect(_on_forward_pressed)
	pause_menu.backward_pressed.connect(_on_backward_pressed)
	
	# @NOTE: yes, this double call is on purpose, the first call initializes everything properly
	set_paused(true)
	if start_game_immediately: set_paused(false)

func _exit_tree() -> void:
	Global.input.open_to_input = false

func set_paused(val:bool) -> void:
	paused = val
	pause_menu.set_enabled(paused)
	if tutorial: tutorial.set_active(paused)
	get_tree().paused = paused
	
	# by default, the pause menu is what allows removing players
	if not disable_removing_if_paused:
		Global.input.pause_mode = paused
	
	# if it's the first unpause, start the game
	if not paused and state == GameState.PREGAME:
		change_state(GameState.GAME)

func change_state(new_state:GameState) -> void:
	state = new_state

func on_objective_registered() -> void:
	var num_players := player_data.count()
	var results_registered := state_data.tracker_temporary.count()
	var all_have_finished := results_registered >= num_players
	if not all_have_finished: return
	
	print("[State] All players finished; should go to game over")
	goto_game_over()

func goto_game_over() -> void:
	change_state(GameState.POSTGAME)
	get_tree().change_scene_to_file("res://pq-obg/game_over/game_over.tscn")

func goto_main_menu() -> void:
	get_tree().change_scene_to_file("res://pq-obg/menu/menu.tscn")

func _unhandled_input(ev:InputEvent) -> void:
	if not paused and ev.is_action_released("ui_backward"):
		set_paused(true)

func _on_backward_pressed() -> void:
	goto_main_menu()

func _on_forward_pressed() -> void:
	set_paused(false)
