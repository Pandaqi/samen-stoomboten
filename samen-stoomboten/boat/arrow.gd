extends Node2D
class_name Arrow

var dir := Vector2i.ZERO
var idx : int = -1
var is_pressed := false
var speed := 0.0

func is_active() -> bool:
	return self.visible

func on_connect_with_player() -> void:
	set_visible(true)
	set_pressed(false)

func set_pressed(val:bool, cur_speed := 0.0) -> void:
	is_pressed = val
	modulate.a = 1.0 if is_pressed else 0.5
	speed = cur_speed

func get_vector() -> Vector2:
	if not is_active(): return Vector2.ZERO
	if not is_pressed: return Vector2.ZERO
	return Vector2(dir).normalized() * speed

func get_button_visualizer_anchor() -> Vector2:
	return global_position + Vector2.from_angle(self.global_rotation) * -64.0
