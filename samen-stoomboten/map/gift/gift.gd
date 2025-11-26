extends Node2D
class_name Gift

enum GiftType
{
	GIFT,
	BOOK,
	CANDY
}

var type : GiftType
var target := Vector2.ZERO
var anchor : Vector2
var is_on_screen := false
var is_in_boat := false

@export var area : Area2D
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

func _ready() -> void:
	anchor = get_position()
	area.body_entered.connect(_on_body_entered)
	anim_player.speed_scale = 0.5 + randf()

func set_type(tp:GiftType) -> void:
	type = tp
	
	if type == GiftType.GIFT:
		sprite.set_frame(randi() % 4)
	if type == GiftType.BOOK:
		sprite.set_frame(6)
	if type == GiftType.CANDY:
		sprite.set_frame(7)

func is_book() -> bool:
	return type == GiftType.BOOK

func is_candy() -> bool:
	return type == GiftType.CANDY

func _on_body_entered(body:Node2D) -> void:
	if not (body is Boat): return
	set_enabled(false)
	body.module_gifts.grab_gift(self)

# We don't actually remove gifts, just disable them
# So we can instantly just ENABLE them back if the boat loses them later
func set_enabled(is_enabled: bool) -> void:
	set_visible(is_enabled)
	area.set_deferred("monitoring", is_enabled)
	is_in_boat = not is_enabled

func set_new_anchor(pos:Vector2) -> void:
	anchor = pos
	set_position(anchor)

func _process(delta: float) -> void:
	move_to_target(delta)

func get_speed() -> float:
	return Global.config.gift_float_speed

func get_radius() -> float:
	return Global.config.gift_float_radius

func move_to_target(delta:float) -> void:
	if target.length() <= 0.01: pick_target()
	var vec_to_target := (target - get_position())
	var dist_to_target := vec_to_target.length()
	var dir_to_target := vec_to_target.normalized()
	set_position(get_position() + dir_to_target * get_speed() * delta)
	
	var has_arrived := dist_to_target <= 3*get_speed()
	if has_arrived:
		pick_target()

func pick_target() -> void:
	var offset := Vector2.from_angle(randf()*2*PI) * (randf()*0.5+0.5) * get_radius()
	var new_pos := anchor + offset
	target = new_pos
	
func eject_to(from:Vector2, to:Vector2) -> void:
	set_scale(Vector2.ONE*1.2)
	set_visible(true)
	set_position(from)
	
	var dur := 0.67
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", to, dur)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, dur)

	await tween.finished
	
	set_new_anchor(to)
	set_enabled(true)

func visible_to_compass() -> bool:
	return (not is_on_screen) and (not is_in_boat)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_on_screen = false
