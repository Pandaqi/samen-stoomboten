extends Node2D
class_name ModuleInput 

@onready var entity = get_parent()

var holder : InputHolder
var button : InputButton
var button_visualizers : Array[ButtonVisualizer] = []
var removal_warning_enabled := false

@export var hold_time := 250.0
@export var button_visualizer_scene : PackedScene
@export var button_visualizer_scale := Vector2(0.33, 0.33)
@export var player_data : PlayerData
@export var num_button_visualizers := 1

signal pressed()
signal released(time_held:float)
signal removal_warning_started()
signal removal_warning_ended()

func activate(new_button:InputButton) -> void:
	button = new_button
	
	# refresh button visualizers
	clear_button_visualizers()
	for i in range(num_button_visualizers):
		add_button_visualizer()
	
	# the holder is responsible for timing length of button press
	if not holder:
		holder = InputHolder.new(button.get_input_map_key(), hold_time)
		holder.held.connect(on_button_held)
		add_child(holder)
	holder.input_key = button.get_input_map_key()

func clear_button_visualizers() -> void:
	for bv in button_visualizers:
		bv.queue_free()
	button_visualizers = []

func add_button_visualizer() -> void:
	button_visualizers.append(create_button_visualizer())

func create_button_visualizer() -> ButtonVisualizer:
	var node = button_visualizer_scene.instantiate()
	add_child(node)
	node.set_tint(player_data.get_color_for(entity))
	node.set_button(button)
	node.set_scale(button_visualizer_scale)
	return node

func _unhandled_input(ev:InputEvent) -> void:
	var key := button.get_input_map_key()
	
	if ev.is_action_pressed(key):
		pressed.emit()
	
	if ev.is_action_released(key):
		released.emit(holder.get_time_since_press())

func on_button_held(time_held:float) -> void:
	check_for_removal(time_held)

func check_for_removal(time_held:float) -> void:
	if not Global.input.can_remove_button_by_hold(button, time_held): return
	
	# turn warnings on/off (for "you're about to remove yourself")
	var removal_time_warning : float = 0.75*Global.input.get_removal_time()
	if not removal_warning_enabled and time_held >= removal_time_warning:
		removal_warning_started.emit()
	if removal_warning_enabled and time_held < removal_time_warning:
		removal_warning_ended.emit()
	
	# actually remove us if needed
	if time_held >= Global.input.get_removal_time():
		Global.input.request_button_removal(button)
