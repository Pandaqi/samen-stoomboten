extends Resource
class_name MapData

var gifts : Array[Gift] = []
var obstacles : Array[Obstacle] = []

var gifts_collected : Array[Gift] = []

var obstacles_hit := 0
var time := 0

func reset() -> void:
	gifts = []
	obstacles = []
	gifts_collected = []
	obstacles_hit = 0
	time = 0
