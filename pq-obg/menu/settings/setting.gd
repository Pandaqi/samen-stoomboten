extends Resource
class_name Setting 

enum Type
{
	CHECKBOX,
	RANGE,
	RANGE_DISCRETE,
	DROPDOWN,
	# @TODO?
}

enum TypeDisplay
{
	NONE,
	INT,
	FLOAT, # default
	VOLUME,
	BOOL,
}

enum TypeUnit
{
	NONE,
	DECIBELS,
	SECONDS,
	MILLISECONDS,
	PIXELS
}

@export var type : Type
@export var type_display := TypeDisplay.FLOAT
@export var type_unit := TypeUnit.NONE
@export var key : String
@export var label : String
@export var section := "Shared"
## @NOTE: very important, don't duplicate settings with a default set, because it will share reference to that one string, which breaks all those resources! Just retype any strings
@export var default : String
@export_multiline var callback : String
@export var min_value := -INF
@export var max_value := INF
@export var step_value := 0
@export var options : Array[Variant] = []
@export_multiline var callback_init : String

@export var needs_theme_refresh := false
@export var needs_input_refresh := false

var value : Variant # last known/changed value
var value_node : Label
var control_node : Control
var label_node : Label

func fast_construct_helper(tp:Type, l:String, k:String, def:String = "") -> Setting:
	type = tp
	label = l
	key = k
	default = def
	return self

func set_section(s:String) -> Setting:
	section = s
	return self

# @NOTE: This must be a string with GDScript code using `v` (input value) and `r` (setting_reader)
func set_callback(f:String) -> Setting:
	callback = f
	return self

func set_numeric_bounds(minimum:float, maximum:float) -> Setting:
	min_value = minimum
	max_value = maximum
	return self

func set_options(opts:Array[Variant]) -> Setting:
	options = opts
	return self

func set_display_type(tp:TypeDisplay) -> Setting:
	type_display = tp
	return self

func initialize(r:SettingReader) -> void:
	run_custom_initialization()
	on_value_changed(r.read_value(self), r)

func reset(r:SettingReader) -> void:
	on_value_changed(get_default(), r)
	force_update_control()

func visualize(r:SettingReader) -> HBoxContainer:
	var hbox := HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 12)
	
	create_label_node()
	create_value_node()
	
	hbox.add_child(label_node)
	
	if type == Type.DROPDOWN:
		value_node.set_visible(false)
		
		var dd := OptionButton.new()
		control_node = dd
		
		for option in options:
			dd.add_item(option)
		
		dd.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dd.item_selected.connect(func(idx:int):
			on_value_changed(dd.get_item_text(idx), r)
		)
	
	if type == Type.CHECKBOX:
		label_node.set_visible(false)
		value_node.set_visible(false)
		
		var cb := CheckButton.new()
		control_node = cb
		
		cb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cb.set_text(label)
		cb.toggled.connect(func(val:bool):
			on_value_changed(val, r)
		)
	
	if type == Type.RANGE or type == Type.RANGE_DISCRETE:
		var slider := HSlider.new()
		control_node = slider
		
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if min_value != -INF: slider.min_value = min_value
		if max_value != INF: slider.max_value = max_value
		
		var step := (slider.max_value - slider.min_value) / 20.0
		if type == Type.RANGE_DISCRETE: 
			slider.min_value = floor(slider.min_value)
			slider.max_value = ceil(slider.max_value)
			step = 1
		
		if step_value > 0: step = step_value
		slider.step = step
		
		slider.value_changed.connect(func(val:float):
			on_value_changed(val, r)
		)
	
	hbox.add_child(control_node)
	hbox.add_child(value_node)
	
	# init call
	on_value_changed(value, r)
	force_update_control()
	
	return hbox

func create_value_node() -> Label:
	value_node = Label.new()
	value_node.custom_minimum_size = Vector2(64,0)
	value_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_node.add_theme_font_override("font", Global.config_shared.font_body_italic)
	value_node.modulate.a = 0.66
	return value_node

func create_label_node() -> Label:
	label_node = Label.new()
	label_node.set_text(label)
	label_node.custom_minimum_size = Vector2(348, 0)
	label_node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label_node

func get_default() -> Variant:
	if default == "": return null
	if default.to_lower().strip_edges(true, true) == "true": return true
	if default.to_lower().strip_edges(true, true) == "false": return false
	if default.is_valid_int(): return int(default)
	if default.is_valid_float(): return float(default)
	return default

func set_default(v:Variant) -> void:
	default = str(v)

func force_update_control() -> void:
	if (control_node is CheckBox) or (control_node is CheckButton):
		control_node.button_pressed = value
	if control_node is HSlider:
		control_node.value = value
	if control_node is OptionButton:
		# @NOTE: this relies on the fact that items are added by just iterating through options in order, so index found this way matches the text string we want
		control_node.select(options.find(value))

func on_value_changed(new_val:Variant, r:SettingReader) -> void:
	# if we have no default set yet, save it now BEFORE overwriting anything, so we read from the true original Global.config
	if get_default() == null:
		set_default(new_val)
	
	# save the value on ourselves, so it permanently enters into the ConfigFile
	value = new_val
	update_display_value()
	r.save_value(self)
	
	# update the value in the global config, if it exists
	# @NOTE: this must come BEFORE the callback, as that relies on all information being set
	if key in Global.config:
		Global.config[key] = new_val
	if key in Global.config_shared:
		Global.config_shared[key] = new_val
	
	# trigger instant modifications on change, if callback set
	run_custom_callback(new_val, r)
	
	if needs_input_refresh:
		Global.input.refresh_button_selection(false)
	if needs_theme_refresh:
		Global.theme.refresh()

# we basically just create a new GDScript with the custom code as the body
# then add it to the tree and run it
func run_custom_callback(val:Variant, r:SettingReader) -> void:
	if not callback: return
	
	var source_code := """
@warning_ignore_start('unused_parameter')
func eval(v,r):
{code}
""".format({ code = indent_callback_string(callback) })
	var script = GDScript.new()
	script.set_source_code(source_code)
	script.reload()
	
	var ref = RefCounted.new()
	ref.set_script(script)
	ref.eval(val, r)

func run_custom_initialization() -> void:
	if not callback_init: return
	
	var source_code := """
@warning_ignore_start('unused_parameter')
func eval(s):
{code}
""".format({ code = indent_callback_string(callback_init) })
	var script = GDScript.new()
	script.set_source_code(source_code)
	script.reload()
	
	var ref = RefCounted.new()
	ref.set_script(script)
	ref.eval(self)

func indent_callback_string(cb:String) -> String:
	cb = cb.replace("\r", "")
	var callback_lines = cb.split("\n")
	for i in range(callback_lines.size()):
		callback_lines[i] = "\t" + callback_lines[i]
	return "\n".join(callback_lines)

func update_display_value() -> void:
	if not value_node: return
	
	var conv_val : Variant = value
	if type_display == TypeDisplay.FLOAT: conv_val = round(value*100.0)/100.0
	if type_display == TypeDisplay.INT: conv_val = int(round(value))
	if type_display == TypeDisplay.VOLUME: conv_val = str(round(linear_to_db(value)))
	if type_display == TypeDisplay.BOOL: conv_val = str(value) # @TODO: could be more specific/smart conversion here, such as 0 = false/1 = true
	
	var text_final := str(conv_val) + get_unit()
	value_node.set_text(text_final)

func get_unit() -> String:
	if type_unit == TypeUnit.DECIBELS: return "dB"
	if type_unit == TypeUnit.SECONDS: return "s" 
	if type_unit == TypeUnit.MILLISECONDS: return "ms"
	if type_unit == TypeUnit.PIXELS: return "px"
	return ""
