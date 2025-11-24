extends Node

@export var config : ConfigData
@export var config_shared : ConfigSharedData

var input : InputManager
var audio : AudioManager

func _ready():
	input = InputManager.new()
	add_child(input)
	
	audio = AudioManager.new()
	add_child(audio)
