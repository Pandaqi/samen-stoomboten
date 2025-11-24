class_name InputHolder extends Node

signal started()
signal held(time_held:float)
signal ended(time_held:float)

var input_key := ""
var delay := 0.0 # milliseconds
var prev_press_time := 0.0
var is_down := false
var is_held := false

func _init(k:String, d:float = 0.0) -> void:
	input_key = k
	delay = d

func _unhandled_input(ev:InputEvent) -> void:
	if ev.is_action_pressed(input_key):
		start_tracking()
	
	if ev.is_action_released(input_key):
		stop_tracking()

func start_tracking() -> void:
	prev_press_time = Time.get_ticks_msec()
	is_down = true
	is_held = false

func hold() -> void:
	is_held = true
	started.emit()

func stop_tracking() -> void:
	is_down = false
	is_held = false
	ended.emit(get_time_held())

func get_time_since_press() -> float:
	if not is_down: return 0
	return Time.get_ticks_msec() - prev_press_time

func get_time_held() -> float:
	return max(get_time_since_press() - delay, 0)

func _process(_dt:float) -> void:
	if not is_down: return
	
	if is_held:
		held.emit(get_time_held())
		return
	
	var should_hold := get_time_since_press() >= delay
	if not should_hold: return
	hold()
