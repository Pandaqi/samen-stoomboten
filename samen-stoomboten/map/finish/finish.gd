extends Node2D
class_name Finish

@export var area : Area2D
@export var sprite : Sprite2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D) -> void:
	if not (body is Boat): return
	print("Boat entered finish area.")
	body.finish()

func resize_to(chunk_size:Vector2) -> void:
	var finish_size := Vector2(128, chunk_size.y)
	
	var col_shape_node := CollisionShape2D.new()
	var col_shape := RectangleShape2D.new()
	col_shape.size = finish_size
	col_shape_node.shape = col_shape
	area.add_child(col_shape_node)
	
	var sprite_base_size := Vector2(128, 128)
	var scale_vec := finish_size / sprite_base_size
	sprite.set_scale(scale_vec)
	sprite.material.set_shader_parameter("zoom", 4.0 * scale_vec)
	
