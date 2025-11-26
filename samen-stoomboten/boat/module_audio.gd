extends Node2D
class_name ModuleAudio

@onready var entity : Boat = get_parent()
@export var audio_player : AudioStreamPlayer2D
@export var audio_water_slosh : AudioStreamPlayer2D
@export var audio_toot : AudioStream
@export var timer : Timer
@export var audio_finish : AudioStream

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	restart_timer()

func play_audio(stream:AudioStream) -> void:
	var playback : AudioStreamPlaybackPolyphonic = audio_player.get_stream_playback()
	playback.play_stream(stream, 0, 0, AudioManager.get_pitch_shift_semitones())

func _process(_delta: float) -> void:
	handle_sloshing()

func handle_sloshing() -> void:
	var should_slosh = entity.get_linear_velocity().length() > 5
	if should_slosh and not audio_water_slosh.is_playing():
		audio_water_slosh.play()
	if not should_slosh and audio_water_slosh.is_playing():
		audio_water_slosh.stop()

func restart_timer() -> void:
	timer.stop()
	timer.wait_time = randf_range(6.0, 15.0)
	timer.start()

func _on_timer_timeout() -> void:
	play_audio(audio_toot)
	restart_timer()

func finish() -> void:
	play_audio(audio_finish)
