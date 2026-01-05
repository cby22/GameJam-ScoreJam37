extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SAVE_PATH = "user://leaderboard.json"
var leaderboard_array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	load_leaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_leaderboard():
	if not File.new().file_exists(SAVE_PATH):
		save_leaderboard()
		return
	
	var file = File.new()
	file.open(SAVE_PATH, File.READ)
	var content = file.get_as_text()
	file.close()
	
	var parse = JSON.parse(content)
	if parse.error == OK:
		leaderboard_array = parse.result
	else:
		print("Failed to load leaderboard. ERROR Code: ", parse.error_string)

func save_leaderboard():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_string(JSON.print(leaderboard_array))
	file.close()

func add_new_score(player_name: String, score: int):
	var new_score = {"name": player_name, "score": score}
	leaderboard_array.append(new_score)
	leaderboard_array.sort()
	
	if leaderboard_array.size() > 10:
		leaderboard_array.resize(10)
	
	save_leaderboard()
