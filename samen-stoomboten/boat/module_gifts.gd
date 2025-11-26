extends Node2D
class_name ModuleGifts

@onready var entity : Boat = get_parent()
@export var map_data : MapData
@export var audio_gift_grab : AudioStream
@export var audio_gift_lose : AudioStream

var gifts : Array[Gift] = []

signal gifts_changed(num_gifts:int)

func count() -> int:
	return gifts.size()

func grab_gift(g:Gift) -> void:
	gifts.append(g)
	gifts_changed.emit(count())
	map_data.gifts_collected = gifts
	entity.play_bounce_tween()
	entity.module_audio.play_audio(audio_gift_grab)
	
	if g.is_book():
		entity.module_compass.activate()
	
	if g.is_candy():
		entity.update_speed_factor(Global.config.candy_speed_factor)

func drop_gift() -> void:
	if count() <= 0: return
	
	entity.module_audio.play_audio(audio_gift_lose)
	
	var last_gift : Gift = gifts.pop_back()
	gifts_changed.emit(count())
	map_data.gifts_collected = gifts
	
	var pos := entity.get_position() + Vector2.from_angle(randf() * 2 * PI) * Global.config.gift_eject_radius
	last_gift.eject_to(entity.get_position(), pos)
