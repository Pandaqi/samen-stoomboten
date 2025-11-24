extends Node2D
class_name Player

var is_moving := false
var arrows : Array[Arrow] = []

const SPEED := 200.0

@export var input : ModuleInput

func _ready() -> void:
	input.pressed.connect(_on_pressed)
	input.released.connect(_on_released)

func _on_pressed() -> void:
	is_moving = true
	for arrow in arrows:
		arrow.set_pressed(true, SPEED)

func _on_released(_time_held:float) -> void:
	is_moving = false
	for arrow in arrows:
		arrow.set_pressed(false)

func clear_connected_arrows() -> void:
	arrows = []
	input.clear_button_visualizers()

func add_connected_arrow(arrow:Node2D) -> void:
	arrows.append(arrow)
	arrow.on_connect_with_player()
	input.add_button_visualizer()
	position_button_visualizers()

func _physics_process(_delta: float) -> void:
	position_button_visualizers()

func position_button_visualizers() -> void:
	var bvis := input.button_visualizers
	for i in range(bvis.size()):
		bvis[i].set_position(arrows[i].get_button_visualizer_anchor())
