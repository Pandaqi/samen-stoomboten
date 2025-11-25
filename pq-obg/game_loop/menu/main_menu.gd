class_name MainMenu extends CanvasLayer

@onready var button_container : VBoxContainer = $Control/CenterContainer/VBoxContainer
@export var settings : Settings

func _ready() -> void:
	if Global.config_shared.clear_input_at_menu: Global.input.clear()
	settings.active_changed.connect(on_settings_active_changed)
	grab_focus()

func grab_focus() -> void:
	button_container.get_child(0).grab_focus()

func release_focus() -> void:
	for child in button_container.get_children():
		child.release_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://" + Global.config_shared.game_id + "/main.tscn")

func _on_settings_pressed() -> void:
	set_visible(false)
	settings.set_active(true)

func on_settings_active_changed(is_active:bool) -> void:
	if not is_active: 
		set_visible(true)
		grab_focus()
	else: release_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()
