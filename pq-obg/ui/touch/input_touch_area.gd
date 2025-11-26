extends Control
class_name InputTouchArea

signal pressed()
signal released()

@export var sprite : Sprite2D
@export var container : Control
var button : InputButton
var base_alpha := 0.5

func _ready() -> void:
	container.gui_input.connect(_on_input_event)
	container.custom_minimum_size = size
	
	var base_scale := Vector2(512.0, 512.0)
	sprite.set_position(0.5*size)
	sprite.set_scale(Vector2.ONE * size / base_scale)
	
	base_alpha = Global.config_shared.touch_area_alpha

func _on_input_event(ev:InputEvent) -> void:
	var is_click := ev is InputEventScreenTouch
	if not is_click: return
	
	if ev.pressed: 
		sprite.modulate.a = 1.5*base_alpha
		pressed.emit()
	else:
		sprite.modulate.a = 1.0*base_alpha
		released.emit()

func set_color(c:Color) -> void:
	sprite.modulate = c
	sprite.modulate.a = base_alpha

func set_button(b:InputButton) -> void:
	button = b

func get_touch_area_index() -> int:
	return button.device
