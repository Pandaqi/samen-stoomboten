extends Node2D
class_name ModuleCollider

@onready var entity : Boat = get_parent()
var num_hits := 0

func _ready() -> void:
	entity.body_entered.connect(_on_body_entered)

func get_body_speed() -> float:
	return entity.get_linear_velocity().length()

func _on_body_entered(body:PhysicsBody2D) -> void:
	if body is Obstacle:
		var speed := get_body_speed() * Global.config.obstacle_hit_damage_multiplier
		body.damage(speed)
		entity.module_gifts.drop_gift()
		entity.play_bounce_tween()
		num_hits += 1
