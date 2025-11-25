extends Resource
class_name MapData

var gifts : Array[Gift] = []
var obstacles : Array[Obstacle] = []

var gifts_collected : Array[Gift] = []

func reset() -> void:
	gifts = []
	obstacles = []
	gifts_collected = []
