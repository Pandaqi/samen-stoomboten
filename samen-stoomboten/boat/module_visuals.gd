extends Node2D
class_name ModuleVisuals

@onready var entity : Node2D = get_parent()
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer


func _process(delta: float) -> void:
	var speed_vec : Vector2 = entity.get_linear_velocity()
	var speed := speed_vec.length()
	anim_player.speed_scale = clamp(speed / 200.0, 0.0, 1.0)
	sprite.flip_h = speed_vec.x < 0
