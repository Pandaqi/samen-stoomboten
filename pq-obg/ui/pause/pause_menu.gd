extends Control
class_name PauseMenu

@onready var pause_menu_container : Control = $CenterContainer
@onready var forward_btn : Button = $CenterContainer/MarginContainer/VBoxContainer/HBoxContainer/Forward
@onready var overlay : Control = $Overlay

signal backward_pressed()
signal forward_pressed()

func _ready() -> void:
	# anchor the pause screen to whatever side we want
	var anchor_tool := ScreenAnchorTool.new(Global.config_shared.pause_menu_anchor)
	anchor_tool.set_control_node(pause_menu_container)

func _on_backward_pressed() -> void:
	backward_pressed.emit()

func _on_forward_pressed() -> void:
	forward_pressed.emit()

func set_enabled(is_enabled: bool) -> void:
	set_visible(is_enabled)
	if is_enabled: forward_btn.grab_focus()
