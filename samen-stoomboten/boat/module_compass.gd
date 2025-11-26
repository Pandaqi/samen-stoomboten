extends Node2D
class_name ModuleCompass

@onready var entity = get_parent()

@export var map_data : MapData
@export var compass_indicator : PackedScene
var compass_nodes : Array[CompassIndicator] = []
@export var compass_container : Node2D
@export var timer : Timer

func _ready() -> void:
	cache_compass_nodes()
	timer.timeout.connect(_on_timer_timeout)
	deactivate()

func activate() -> void:
	compass_container.show()
	
	timer.stop()
	timer.wait_time = Global.config.book_compass_duration
	timer.start()

func deactivate() -> void:
	compass_container.hide()

func _on_timer_timeout() -> void:
	deactivate()

func cache_compass_nodes() -> void:
	var num : int = Global.config.max_compass_indicators
	for i in range(num):
		var n = compass_indicator.instantiate()
		compass_container.add_child(n)
		n.set_visible(false)
		compass_nodes.append(n)
	compass_container.get_parent().remove_child(compass_container)
	entity.map_overlay.add_child(compass_container)

func _physics_process(_delta: float) -> void:
	for node in compass_nodes:
		node.set_visible(false)
	
	var gifts := map_data.gifts
	var gifts_visible : Array[Gift] = gifts.filter(func(x): return x.visible_to_compass())
	gifts_visible.sort_custom(func(a,b):
		var dist_a := global_position.distance_squared_to(a.global_position)
		var dist_b := global_position.distance_squared_to(b.global_position)
		return dist_a <= dist_b
	)
	
	var radius : float = Global.config.compass_radius
	var gifts_to_mark := gifts_visible.slice(0, compass_nodes.size())
	var max_dist := Global.config.compass_max_dist_to_gift
	for i in range(gifts_to_mark.size()):
		var gift : Gift = gifts_to_mark[i]
		var vec_to_gift := gift.global_position - global_position
		var dist_to_gift := vec_to_gift.length()

		var node = compass_nodes[i]
		node.show()
		node.global_position = global_position + vec_to_gift.normalized() * radius
		node.modulate.a = clamp(1.0 - dist_to_gift/max_dist, 0, 1.0)
