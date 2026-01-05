extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var leader_name = ""
var leader_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Name.text = leader_name
	$Score.text = str(leader_score)
