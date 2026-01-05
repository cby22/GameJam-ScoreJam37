extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ball_hit_car = false

var rng = RandomNumberGenerator.new()
var dir_rng = null

var speed = 100
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	dir_rng = rng.randi_range(0, 100)
	add_to_group("obstacle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var direction = null
	if dir_rng < 60:
		direction = -1
	else:
		direction = 1
	velocity.x = direction

	global_position += velocity * speed * delta


func _on_Car_Moving_body_entered(body):
	if body.is_in_group("ball"):
		ball_hit_car = true
