extends Resource
class_name PlayerData

var players : Array[Player] = []
var colors_available : Array[Color] = []
var colors_used : Array[Color] = []

func reset() -> void:
	players = []
	colors_available = generate_all_possible_colors()
	colors_used = []

func add_player(p:Player) -> void:
	colors_used.append(colors_available.pop_front())
	players.append(p)

func remove_player(p:Player) -> void:
	var col := get_color_for(p)
	colors_used.erase(col)
	colors_available.append(col)
	players.erase(p)

func count() -> int:
	return players.size()

func get_player_num_for(p:Player) -> int:
	return players.find(p)

func get_color_for(p:Player) -> Color:
	return colors_used[get_player_num_for(p)]

# @TODO: how to add easy SIGNALS for when this has changed? Through the ModuleScore script?
func get_score_for_team(team_num:int) -> float:
	var sum := 0.0
	for player in players:
		var team := -1
		if player.has_node("ModuleStatus"):
			team = player.get_node("ModuleStatus").get_team()
		if team != team_num: continue
		
		var score := 0
		if player.has_node("ModuleScore"):
			score = player.get_node("ModuleScore").get_score()
		sum += score
	return sum

func generate_all_possible_colors() -> Array[Color]:
	var arr : Array[Color] = []
	
	# generate equidistant colors
	var rand_hue_offset := randf_range(0.0, 1.0)
	var max_colors := 20
	for i in range(max_colors):
		var hue := rand_hue_offset + i * (1.0 / float(max_colors))
		var new_color := Color.from_hsv(hue, 1.0, 1.0)
		arr.append(new_color)
	
	# sort based on contrast (highest-contrast between two subsequent colors; this takes into account hue and saturation and stuff)
	var prev_color : Color = arr.pop_front()
	var arr_sorted : Array[Color] = [prev_color]
	while arr.size() > 0:
		var biggest_contrast = 0
		var best_color
		for elem in arr:
			var contrast := (elem.get_luminance() + 0.05) / (prev_color.get_luminance() + 0.5)
			if contrast <= biggest_contrast: continue
			biggest_contrast = contrast
			best_color = elem
		arr.erase(best_color)
		arr_sorted.append(best_color)
	
	return arr_sorted
