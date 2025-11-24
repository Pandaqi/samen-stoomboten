class_name ButtonInstructions extends CanvasLayer

@export var button_instruction_scene : PackedScene
var instructions : Array[ButtonInstruction] = []

const instruction_size := Vector2(1024, 512)
@export var margin_off_edge := Vector2(100, 100)
var anchor_tool : ScreenAnchorTool

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	create_instructions()
	Global.input.buttons_changed.connect(on_buttons_changed)
	prepare_anchor_tool()
	on_buttons_changed()

func create_instructions() -> void:
	for i in range(4):
		var instruc : ButtonInstruction = button_instruction_scene.instantiate()
		add_child(instruc)
		instructions.append(instruc)
		instruc.hide()

func prepare_anchor_tool() -> void:
	anchor_tool = ScreenAnchorTool.new(
		Global.config_shared.button_instructions_anchor,
		instruction_size, Global.config_shared.button_instructions_sprite_scale, 
		margin_off_edge
	)
	add_child(anchor_tool)

func on_buttons_changed() -> void:
	# set everything to the right (next) button
	var all_types := Global.input.get_all_input_types()
	var counter := 0
	for type in all_types:
		var btn := Global.input.get_next_button(type)
		if not btn: continue
		instructions[counter].activate(btn, ButtonInstruction.Type.LOGIN)
		counter += 1
	
	# go one ahead to show the logout instruction too
	# @TODO: might be removed now that this instruction is in pause menu
	instructions[counter].activate(null, ButtonInstruction.Type.LOGOUT)
	counter += 1
	
	# tell anchor tool to show all elements that should be visible
	anchor_tool.show_elements(instructions.slice(0, counter))
