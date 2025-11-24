extends Node2D
class_name Gift

var target := Vector2.ZERO
const SPEED := 10.0
const RADIUS := 256.0
var anchor : Vector2

@export var area : Area2D
@export var sprite : Sprite2D
@export var anim_player : AnimationPlayer

func _ready() -> void:
	anchor = get_position()
	area.body_entered.connect(_on_body_entered)
	sprite.set_frame(randi() % 4)
	anim_player.speed_scale = 0.5 + randf()

func _on_body_entered(body:Node2D) -> void:
	if not (body is Boat): return
	set_enabled(false)
	body.module_gifts.grab_gift(self)

# We don't actually remove gifts, just disable them
# So we can instantly just ENABLE them back if the boat loses them later
func set_enabled(is_enabled: bool) -> void:
	set_visible(is_enabled)
	area.set_deferred("monitoring", is_enabled)

func set_new_anchor(pos:Vector2) -> void:
	anchor = pos
	set_position(anchor)

func _process(delta: float) -> void:
	move_to_target(delta)

func move_to_target(delta:float) -> void:
	if target.length() <= 0.01: pick_target()
	var vec_to_target := (target - get_position())
	var dist_to_target := vec_to_target.length()
	var dir_to_target := vec_to_target.normalized()
	set_position(get_position() + dir_to_target * SPEED * delta)
	
	var has_arrived := dist_to_target <= 3*SPEED
	if has_arrived:
		pick_target()

func pick_target() -> void:
	var offset := Vector2.from_angle(randf()*2*PI) * (randf()*0.5+0.5) * RADIUS
	var new_pos := anchor + offset
	target = new_pos
	
