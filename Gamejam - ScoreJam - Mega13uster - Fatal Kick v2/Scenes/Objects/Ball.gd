extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 200

export var rotation_speed = 10.0

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("ball")
	$Fire_vfx.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_up") and position.y > 152 - 108 and GlobalVar.game_not_over:
		position.y -= 64
	if Input.is_action_just_pressed("ui_down") and position.y < 152 + 108 and GlobalVar.game_not_over:
		position.y += 64
	
	if GlobalVar.fireball:
		$Fire_vfx.visible = true
	else:
		$Fire_vfx.visible = false
	
	if speed < 0:
		speed = 0
		rotation_speed = 0.0
	elif speed < 100:
		rotation_speed = 5.0
	elif speed < 50:
		rotation_speed = 2.5

func _physics_process(delta):
	# constantly move in one direction
	# Used Google AI Overview for generic code then modified
	if GlobalVar.game_start:
		var direction = 1
		velocity.x = direction * speed
		
		# Used Google AI Overview for rotation logic
		$Sprite.rotation += rotation_speed * delta 
	velocity = move_and_slide(velocity)
