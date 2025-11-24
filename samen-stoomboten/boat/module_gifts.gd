extends Node2D
class_name ModuleGifts

@onready var entity : Node2D = get_parent()

const EJECT_RADIUS := 256.0

var gifts : Array[Gift] = []

signal gifts_changed(num_gifts:int)

func count() -> int:
	return gifts.size()

func grab_gift(g:Gift) -> void:
	gifts.append(g)
	gifts_changed.emit(count())

func drop_gift() -> void:
	if count() <= 0: return
	var last_gift : Gift = gifts.pop_back()
	var pos := entity.get_position() + Vector2.from_angle(randf() * 2 * PI) * EJECT_RADIUS
	last_gift.set_new_anchor(pos)
	last_gift.set_enabled(true)
	gifts_changed.emit(count())
