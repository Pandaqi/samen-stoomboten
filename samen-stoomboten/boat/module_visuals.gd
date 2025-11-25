extends Node2D
class_name ModuleVisuals

@onready var entity : Node2D = get_parent()
@export var sprite_container : Node2D
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer
@export var anim_player_water : AnimationPlayer

func _process(delta: float) -> void:
	var speed_vec : Vector2 = entity.get_linear_velocity()
	var speed := speed_vec.length()
	var anim_speed_scale : float = clamp(speed / 200.0, 0.0, 1.0)
	anim_player.speed_scale = anim_speed_scale
	anim_player_water.speed_scale = anim_speed_scale
	sprite_container.scale.x = -1 if speed_vec.x < 0 else 1
