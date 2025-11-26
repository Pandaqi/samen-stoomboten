extends Node
class_name ThemeManager

func _ready() -> void:
	refresh()

func refresh():
	var cfg = Global.config_shared
	var th : Theme = cfg.theme
	
	#
	# Main Properties
	#
	th.default_font = cfg.font_body_regular
	th.default_font_size = cfg.font_size
	
	#
	# Prepare Style Boxes for Reuse
	#
	var sb_normal := StyleBoxFlat.new()
	sb_normal.bg_color = cfg.color_normal_bg
	sb_normal.border_color = cfg.border_color_normal
	sb_normal.set_border_width_all(cfg.border_width)
	sb_normal.set_corner_radius_all(cfg.border_radius)
	sb_normal.set_content_margin_all(cfg.border_margin)
	sb_normal.shadow_size = cfg.shadow_size_normal
	sb_normal.shadow_color = cfg.color_shadow
	sb_normal.shadow_offset = cfg.shadow_offset
	
	var sb_focus := StyleBoxFlat.new()
	sb_focus.bg_color = cfg.color_focus_bg
	sb_focus.border_color = cfg.border_color_focus
	sb_focus.set_border_width_all(cfg.border_width)
	sb_focus.set_corner_radius_all(cfg.border_radius)
	sb_focus.set_content_margin_all(cfg.border_margin)
	sb_focus.shadow_size = cfg.shadow_size_focus
	sb_focus.shadow_color = cfg.color_shadow
	sb_focus.shadow_offset = cfg.shadow_offset
	
	var sb_hover := StyleBoxFlat.new()
	sb_hover.bg_color = cfg.color_hover_bg
	sb_hover.border_color = cfg.border_color_hover
	sb_hover.set_border_width_all(cfg.border_width)
	sb_hover.set_corner_radius_all(cfg.border_radius)
	sb_hover.set_content_margin_all(cfg.border_margin)
	sb_hover.shadow_size = cfg.shadow_size_hover
	sb_hover.shadow_color = cfg.color_shadow
	sb_hover.shadow_offset = cfg.shadow_offset
	
	var sb_panel := StyleBoxFlat.new()
	sb_panel.bg_color = cfg.color_panel_bg
	sb_panel.border_color = cfg.border_color_panel
	sb_panel.set_border_width_all(cfg.border_width)
	sb_panel.set_corner_radius_all(cfg.border_radius)
	sb_panel.set_content_margin_all(cfg.border_margin_panel)
	sb_panel.shadow_size = cfg.shadow_size_panel
	sb_panel.shadow_color = cfg.color_shadow
	sb_panel.shadow_offset = cfg.shadow_offset
	
	#
	# Button
	# @NOTE: The Button styles are directly inherited by a lot of other things (e.g. CheckButton, OptionButton)
	# So making sure these are correct and set here is important
	#
	th.set_font("font", "Button", cfg.font_heading)
	th.set_font_size("font_size", "Button",cfg.button_font_size)
	th.set_stylebox("focus", "Button", sb_focus)
	th.set_stylebox("hover", "Button", sb_hover)
	th.set_stylebox("pressed", "Button", sb_hover)
	th.set_stylebox("normal", "Button", sb_normal)
	
	th.set_color("font_color", "Button", cfg.color_normal_text)
	th.set_color("font_focus_color", "Button", cfg.color_focus_text)
	th.set_color("font_hover_color", "Button", cfg.color_hover_text)
	th.set_color("font_pressed_color", "Button", cfg.color_hover_text)
	th.set_color("font_hover_pressed_color", "Button", cfg.color_normal_text)
	
	#
	# OptionButton
	#
	th.set_font("font", "OptionButton", cfg.font_body_regular)
	
	#
	# CheckButton
	#
	th.set_font("font", "CheckButton", cfg.font_body_regular)
	th.set_stylebox("normal", "CheckButton", StyleBoxEmpty.new())
	th.set_stylebox("hover", "CheckButton", StyleBoxEmpty.new())
	
	#
	# Label
	#
	th.set_font("font", "Label", cfg.font_body_regular)
	th.set_color("font_color", "Label", cfg.label_color)
	th.set_font_size("font_size", "Label", cfg.label_font_size)
	
	#
	# RichTextLabel
	#
	th.set_font("normal_font", "RichTextLabel", cfg.font_body_regular)
	th.set_font("bold_font", "RichTextLabel", cfg.font_body_bold)
	th.set_font("bold_italics_font", "RichTextLabel", cfg.font_body_bold_italic)
	th.set_font("italics_font", "RichTextLabel", cfg.font_body_italic)
	
	th.set_font_size("normal_font_size", "RichTextLabel", cfg.label_font_size)
	th.set_font_size("bold_font_size", "RichTextLabel", cfg.label_font_size)
	th.set_font_size("bold_italics_font_size", "RichTextLabel", cfg.label_font_size)
	th.set_font_size("italics_font_size", "RichTextLabel",cfg.label_font_size)
	
	#
	# TabContainer
	#
	th.set_font("font", "TabContainer", cfg.font_heading)
	th.set_stylebox("panel", "TabContainer", StyleBoxEmpty.new())
	th.set_stylebox("tab_focus", "TabContainer", sb_focus)
	th.set_stylebox("tab_hovered", "TabContainer", sb_hover)
	th.set_stylebox("tab_selected", "TabContainer", sb_focus)
	th.set_stylebox("tab_unselected", "TabContainer", sb_normal)
	
	#
	# PanelContainer
	#
	th.set_stylebox("panel", "PanelContainer", sb_panel)
	
	#
	# HSlider
	#
	th.set_stylebox("grabber_area", "HSlider", sb_normal) # @TODO? A third "sb_area" or "sb_progress" thing?
	th.set_stylebox("grabber_area_highlight", "HSlider", sb_focus)
	th.set_stylebox("slider", "HSlider", sb_hover)
	
	#
	# MarginContainer
	#
	th.set_constant("margin_bottom", "MarginContainer", cfg.container_margin_default)
	th.set_constant("margin_top", "MarginContainer", cfg.container_margin_default)
	th.set_constant("margin_left", "MarginContainer", cfg.container_margin_default)
	th.set_constant("margin_right", "MarginContainer", cfg.container_margin_default)
	
	#
	# HBox / VBox
	#
	th.set_constant("separation", "HBoxContainer", cfg.container_separation_default)
	th.set_constant("separation", "VBoxContainer", cfg.container_separation_default)
	
	#
	# Tooltips
	#
	th.set_color("font_color", "TooltipLabel", Color.WHITE)
