extends Node2D
class_name ModuleGifts

@onready var entity : Boat = get_parent()
@export var map_data : MapData

var gifts : Array[Gift] = []

signal gifts_changed(num_gifts:int)

func count() -> int:
	return gifts.size()

func grab_gift(g:Gift) -> void:
	gifts.append(g)
	gifts_changed.emit(count())
	map_data.gifts_collected = gifts
	entity.play_bounce_tween()

func drop_gift() -> void:
	if count() <= 0: return
	var last_gift : Gift = gifts.pop_back()
	gifts_changed.emit(count())
	map_data.gifts_collected = gifts
	
	var pos := entity.get_position() + Vector2.from_angle(randf() * 2 * PI) * Global.config.gift_eject_radius
	last_gift.eject_to(entity.get_position(), pos)
