extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var ball_hit_speed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("speed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Speed_Buff_body_entered(body):
	if body.is_in_group("ball"):
		ball_hit_speed = true
		if not GlobalVar.fireball:
			body.speed += 25

