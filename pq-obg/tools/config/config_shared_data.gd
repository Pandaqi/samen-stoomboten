extends Resource
class_name ConfigSharedData

@export var game_id : String = "game-id"
@export var clear_input_at_menu := true
@export var language_default := "en"

@export_group("Settings")
@export var settings : Array[SettingTab] = [preload("res://pq-obg/settings/default/tab_core.tres")] # resources for SettingTabs to display

@export_group("Audio")
@export var audio_bg : Array[AudioStream] = []
@export var audio_busses : Array[String] = []

@export_group("Theme")
@export var theme : Theme = preload("res://pq-obg/ui/default_theme.tres")

@export_subgroup("Background")
@export var bg_color := Color.WHITE
@export var bg_image : Texture2D

@export_subgroup("Fonts")
@export var font_size : int = 16
@export var font_body_regular : FontFile
@export var font_body_italic : FontFile
@export var font_body_bold : FontFile
@export var font_body_bold_italic : FontFile
@export var font_heading : FontFile
@export var font_special : FontFile

@export_subgroup("Colors")
@export var color_normal_bg := Color(0.941, 0.867, 0.788)
@export var color_normal_text := Color(0.239, 0.18, 0.0)
@export var color_focus_bg := Color(0.651, 0.176, 0.329)
@export var color_focus_text := Color(1.0, 0.671, 0.757)
@export var color_hover_bg := Color(0.376, 0.212, 0.082)
@export var color_hover_text := Color(1.0, 0.878, 0.8)
@export var color_panel_bg := Color(0.941, 0.867, 0.788)
@export var color_panel_text := Color.BLACK
@export var color_shadow := Color(0.0, 0.0, 0.0, 0.4)

@export_subgroup("Shadows")
@export var shadow_offset := Vector2(0,4)
@export var shadow_size_normal := 0.0
@export var shadow_size_focus := 0.0
@export var shadow_size_hover := 0.0
@export var shadow_size_panel := 0.0

@export_subgroup("Borders")
@export var border_radius := 12
@export var border_margin := 4
@export var border_margin_panel := 10
@export var border_width := 2
@export var border_color_normal := Color.TRANSPARENT
@export var border_color_focus := Color.TRANSPARENT
@export var border_color_hover := Color.TRANSPARENT
@export var border_color_panel := Color(0.941, 0.545, 0.475)

@export_subgroup("Labels")
@export var label_color := Color.BLACK
@export var label_font_size : int = 16

@export_subgroup("Buttons")
@export var button_font_size : int = 32

@export_group("Input")
@export var input_min_players_bound := 2
@export var input_max_players_bound := 8
@export var input_max_players := 8
@export var input_allow_keyboard := true
@export var input_allow_mouse := true
@export var input_allow_gamepad := true
@export var input_login_while_playing := true
@export var input_logout_while_playing := true
@export var input_logout_hold_duration := 3000.0

# how people are scored/ranked/win per match/round
@export_group("Match Objective")
@export var match_victory_type := Objective.VictoryType.TIME
@export var match_victory_extreme := Objective.VictoryExtreme.LOWEST
@export var match_victory_metric := Objective.VictoryMetric.RANKING

# how people are tracked in overall standings (across multiple matches)
@export_group("Game Objective")
@export var game_victory_type := Objective.VictoryType.POINTS
@export var game_victory_extreme := Objective.VictoryExtreme.LOWEST
@export var game_victory_metric := Objective.VictoryMetric.RANKING
@export var game_victory_conversion := Objective.VictoryConversion.RANKING

@export_group("Tutorial")
@export var tutorial_spritesheet_key := "tutorials"
@export var tutorial_spritesheet_frames := Vector2(4,1)
@export var tutorial_delay := 3 # seconds before next tutorial appears
@export var tutorial_sprite_scale := 1.0
@export var tutorial_only_once := false # if so, doesn't repeat the tutorial any time you pause

@export_group("UI")
@export var button_instructions_anchor := ScreenAnchorTool.Anchor.TOP
@export var button_instructions_sprite_scale := 1.0
@export var tutorial_anchor := ScreenAnchorTool.Anchor.CENTER
@export var pause_menu_anchor := ScreenAnchorTool.Anchor.BOTTOM
