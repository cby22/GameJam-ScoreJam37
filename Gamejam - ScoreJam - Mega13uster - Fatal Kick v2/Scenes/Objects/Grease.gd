extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("grease")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Grease_body_entered(body):
	if body.is_in_group("ball"):
		if not GlobalVar.fireball:
			body.speed -= 100
