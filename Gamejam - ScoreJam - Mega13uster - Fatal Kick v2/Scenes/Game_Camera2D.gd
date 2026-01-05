extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = $"../Ball".position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Used Google AI Overview for how to track an object on only the x-axis
	if GlobalVar.game_start:
		position.x = $"../Ball".position.x + 128

