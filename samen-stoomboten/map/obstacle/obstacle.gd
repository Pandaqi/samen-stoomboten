extends StaticBody2D
class_name Obstacle

var health := 1.0

func damage(val:float) -> void:
	health -= val
	if health <= 0:
		call_deferred("queue_free")
