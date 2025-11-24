class_name Settings extends CanvasLayer

@onready var tab_container : TabContainer = $CenterContainer/VBoxContainer/TabContainer
@export var settings_default : Array[SettingTab] = []

var active := false
var all_tabs : Array[SettingTab] = []
var reader : SettingReader

signal active_changed(ac:bool)

func _ready() -> void:
	collect_all_tabs()
	initialize()
	visualize()
	set_active(false)

func collect_all_tabs() -> void:
	reader = SettingReader.new()
	
	var custom_settings : Array[SettingTab] = []
	if "settings" in Global.config:
		custom_settings = Global.config.settings
	all_tabs = get_default_settings() + custom_settings

func set_active(val:bool) -> void:
	active = val
	set_visible(val)
	active_changed.emit(active)
	
	# @NOTE: we need `get_tab_bar` to select the actual tabs, otherwise this just does nothing on a TabContainer => took a lot of research to figure this out!
	if active: 
		tab_container.get_tab_bar().grab_focus()

func initialize() -> void:
	for tab in all_tabs:
		tab.initialize(reader)

func visualize() -> void:
	for tab in all_tabs:
		tab_container.add_child(tab.visualize(reader))

func get_default_settings() -> Array[SettingTab]:
	return settings_default.duplicate(false)

func _on_close_pressed() -> void:
	set_active(false)

func _on_reset_pressed() -> void:
	for tab in all_tabs:
		tab.reset(reader)

func _unhandled_input(ev:InputEvent) -> void:
	if not active: return
	if ev.is_action_released("ui_backward"):
		_on_close_pressed()
