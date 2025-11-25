extends Node2D
class_name ModuleCompass

@export var map_data : MapData
@export var compass_texture : Texture
var compass_nodes : Array[Sprite2D] = []

func _ready() -> void:
	cache_compass_nodes()

func cache_compass_nodes() -> void:
	var num : int = Global.config.max_compass_indicators
	for i in range(num):
		var n = Sprite2D.new()
		add_child(n)
		n.texture = compass_texture
		n.set_scale(0.075*Vector2.ONE)
		n.set_visible(false)
		n.modulate = Color.BLACK
		compass_nodes.append(n)

func _physics_process(delta: float) -> void:
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
	for i in range(gifts_to_mark.size()):
		var gift : Gift = gifts_to_mark[i]
		var vec_to_gift := gift.global_position - global_position
		var dist_to_gift := vec_to_gift.length()

		var node = compass_nodes[i]
		node.show()
		node.global_position = global_position + vec_to_gift.normalized() * radius
		node.modulate.a = clamp(1.0 - dist_to_gift/3000.0, 0, 1.0)
