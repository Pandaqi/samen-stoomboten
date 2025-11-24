extends Resource
class_name ConfigSharedData

@export var game_id : String = "game-id"
@export var clear_input_at_menu := true

@export_group("Input")
@export var input_allow_keyboard := true
@export var input_allow_mouse := true
@export var input_allow_gamepad := true
@export var input_login_while_playing := true
@export var input_logout_while_playing := true
@export var input_logout_hold_duration := 3000.0
@export var input_max_players := 10

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
@export var setting_font_bold := "res://pq-obg/ui/fonts/body_black.ttf"
