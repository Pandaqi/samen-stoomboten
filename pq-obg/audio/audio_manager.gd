class_name AudioManager extends Node

enum AudioBus
{
	BG,
	MAIN,
	UI
}

var busses : Array
var bg_streams : Array[AudioStream] = []
var bg_audio : AudioStreamPlayer

func _ready() -> void:
	prepare_busses()
	create_bg_music()

func get_bus_name(idx:AudioBus) -> String:
	return AudioBus.keys()[idx]

func prepare_busses() -> void:
	busses = AudioBus.keys()
	var custom_busses = Global.config_shared.audio_busses
	if custom_busses and custom_busses.size() > 0:
		busses = Global.config_shared.audio_busses
	
	var counter := 0
	for bus in busses:
		AudioServer.add_bus()
		AudioServer.set_bus_name(counter, bus)

func get_index_of_bus(key:String) -> int:
	return busses.find(key)

func change_volume_of_bus(key:String, vol:int) -> void:
	AudioServer.set_bus_volume_db(get_index_of_bus(key), vol)

func create_bg_music() -> void:
	if not Global.config_shared.audio_bg: return
	
	bg_streams = Global.config_shared.audio_bg
	var node = AudioStreamPlayer.new()
	node.process_mode = Node.PROCESS_MODE_ALWAYS
	node.bus = get_bus_name(AudioBus.BG)
	node.finished.connect(_on_bg_music_finished)
	
	bg_audio = node
	add_child(node)
	
	pick_next_bg_music()

func _on_bg_music_finished() -> void:
	pick_next_bg_music()

func pick_next_bg_music() -> void:
	if bg_streams.size() <= 0: return
	bg_audio.stream = bg_streams.pick_random()
	bg_audio.play()

func set_bg_paused(val:bool) -> void:
	if val: bg_audio.stop()
	else: bg_audio.play()
