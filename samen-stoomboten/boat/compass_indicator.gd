extends Node2D
class_name CompassIndicator

@export var anim_player : AnimationPlayer

func _ready():
	anim_player.speed_scale = randf()*0.4 + 0.8
