class_name AudioManager extends Node

@export var busses := ["bg", "main"]

func _ready() -> void:
	prepare_busses()

func prepare_busses() -> void:
	var counter := 0
	for bus in busses:
		AudioServer.add_bus()
		AudioServer.set_bus_name(counter, bus)

func get_index_of_bus(key:String) -> int:
	return busses.find(key)

func change_volume_of_bus(key:String, vol:int) -> void:
	AudioServer.set_bus_volume_db(get_index_of_bus(key), vol)
