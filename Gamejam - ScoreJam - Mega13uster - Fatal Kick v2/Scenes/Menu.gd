extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var LeaderDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	$HelpGuide.visible = false
	$LeaderboardContainer.visible = false
	for leaders in SavePath.leaderboard_array:
		var leader_display = LeaderDisplay.instance()
		leader_display.leader_name = leaders["name"]
		leader_display.leader_score = leaders["score"]
		$LeaderboardContainer/LeaderboardArea/VBoxContainer.add_child(leader_display)
		print("im added")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_Leaderboard_pressed():
	$LeaderboardContainer.visible = true


func _on_Back_pressed():
	$LeaderboardContainer.visible = false


func _on_Help_pressed():
	$HelpGuide.visible = true


func _on_HelpBack_pressed():
	$HelpGuide.visible = false
