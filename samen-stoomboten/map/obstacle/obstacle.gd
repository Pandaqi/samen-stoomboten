extends StaticBody2D
class_name Obstacle

var health := 1.0

@export var col_shape : CollisionShape2D
@export var timer : Timer
@export var map_data : MapData

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	var dist_to_boat = global_position.distance_to(map_data.boat.global_position)
	if dist_to_boat < Global.config.min_dist_between_objects: 
		plan_return()
		return
	
	activate()

func activate() -> void:
	show()
	col_shape.disabled = false
	health = 1.0

func deactivate() -> void:
	col_shape.set_deferred("disabled", true)
	hide()
	plan_return()

func damage(val:float) -> void:
	health -= val
	if health > 0: return
	deactivate()

func plan_return() -> void:
	timer.stop()
	timer.wait_time = Global.config.obstacle_return_delay
	timer.start()
