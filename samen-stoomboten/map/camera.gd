extends Camera2D

@export var target : Boat

func _process(delta: float) -> void:
	if not target: return
	set_position(target.get_position())
