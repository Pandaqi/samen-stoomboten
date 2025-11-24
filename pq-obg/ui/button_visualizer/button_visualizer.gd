extends Node2D
class_name ButtonVisualizer 

const KEYBOARD_FRAME := 0
const MOUSE_FRAME := 1
const GAMEPAD_FRAME := 2

var button : InputButton

@onready var sprite_ui : Sprite2D = $SpriteUI

@onready var keyboard_label : Label = $KeyboardLabel
@onready var gamepad_label : Label = $GamepadLabel

@onready var sub_sprites : Node2D = $SubSprites

@onready var mouse_left : Sprite2D = $SubSprites/MouseLeft
@onready var mouse_right : Sprite2D = $SubSprites/MouseRight
@onready var mouse_middle : Sprite2D = $SubSprites/MouseMiddle

@onready var gamepad_left : Sprite2D = $SubSprites/GamepadLeft
@onready var gamepad_right : Sprite2D = $SubSprites/GamepadRight
@onready var gamepad_top : Sprite2D = $SubSprites/GamepadTop
@onready var gamepad_bottom : Sprite2D = $SubSprites/GamepadBottom

@export var tint_color_highlight := Color(1,0,0)
@export var tint_color_bg := Color(1,1,1)

func set_button(btn:InputButton) -> void:
	button = btn
	
	# background UI per type
	sprite_ui.set_frame(get_frame())
	sprite_ui.modulate = tint_color_bg
	
	# first hide all children
	for sprite in sub_sprites.get_children():
		sprite.set_visible(false)
	
	# then only show+tint the relevant one(s)
	# @TODO: write cleaner once we have typed dictionaries that can take enum/constant keys
	if is_mouse():
		var mouse_node = mouse_left
		if btn.key == MOUSE_BUTTON_MIDDLE: mouse_node = mouse_middle
		elif btn.key == MOUSE_BUTTON_RIGHT: mouse_node = mouse_right
		mouse_node.set_visible(true)
		mouse_node.modulate = tint_color_highlight
	
	if is_gamepad():
		var gamepad_node = gamepad_top
		if btn.key == JOY_BUTTON_A: gamepad_node = gamepad_right
		elif btn.key == JOY_BUTTON_B: gamepad_node = gamepad_bottom
		elif btn.key == JOY_BUTTON_X: gamepad_node = gamepad_left
		gamepad_node.set_visible(true)
		gamepad_node.modulate = tint_color_highlight
	
	# show exact keyboard button (if needed) => special case because it needs text, so not a "SubSprite"
	keyboard_label.set_visible(is_keyboard())
	keyboard_label.set_text(btn.get_input_hint_string())
	
	# show exact gamepad device (if needed)
	gamepad_label.set_visible(is_gamepad())
	gamepad_label.set_text(str(btn.device + 1))

func is_keyboard() -> bool:
	return button.type == InputButton.InputType.KEYBOARD

func is_mouse() -> bool:
	return button.type == InputButton.InputType.MOUSE

func is_gamepad() -> bool:
	return button.type == InputButton.InputType.GAMEPAD

func set_tint(c:Color) -> void:
	tint_color_bg = c

func get_frame() -> int:
	if is_keyboard(): return KEYBOARD_FRAME
	if is_mouse(): return MOUSE_FRAME
	if is_gamepad(): return GAMEPAD_FRAME
	return 0
