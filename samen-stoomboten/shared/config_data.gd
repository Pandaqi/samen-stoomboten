extends Resource
class_name ConfigData

@export var settings : Array[SettingTab] = []
@export var tutorials : Array[TutorialStage] = []

@export_group("Boat")
@export_subgroup("Movement")
@export var player_acceleration := 35.0
@export var player_switch_speed := 10.0
@export var invincibility_duration := 5.0
@export var switch_timer_duration := randf_range(1, 4)

@export_group("Map")
