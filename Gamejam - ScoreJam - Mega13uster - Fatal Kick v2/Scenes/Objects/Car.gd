extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 100

var ball_hit_car = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("obstacle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _on_Car_body_entered(body):
	if body.is_in_group("ball"):
		ball_hit_car = true
