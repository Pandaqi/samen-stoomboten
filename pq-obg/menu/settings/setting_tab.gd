extends Resource
class_name SettingTab

@export var groups : Array[SettingGroup] = []
@export var label : String

func set_label(l:String) -> SettingTab:
	label = l
	return self

func add(s:SettingGroup) -> void:
	groups.append(s)

func initialize(r:SettingReader) -> void:
	for group in groups:
		group.initialize(r)

func reset(r:SettingReader) -> void:
	for group in groups:
		group.reset(r)

func visualize(r:SettingReader) -> ScrollContainer:
	var scroll := ScrollContainer.new()
	scroll.name = label # @NOTE: that name is used for the tab names in TabContainer parent 
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.follow_focus = true
	
	var margin_cont := MarginContainer.new()
	var margin := 16
	margin_cont.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin_cont.add_theme_constant_override("margin_top", margin)
	margin_cont.add_theme_constant_override("margin_left", int(0.25*margin))
	margin_cont.add_theme_constant_override("margin_right", int(0.25*margin))
	margin_cont.add_theme_constant_override("margin_bottom", margin)
	scroll.add_child(margin_cont)
	
	var vbox := VBoxContainer.new()
	var v_sep := int(0.5*margin)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", v_sep)
	margin_cont.add_child(vbox)
	
	for group in groups:
		vbox.add_child(group.visualize(r))
	
	return scroll
