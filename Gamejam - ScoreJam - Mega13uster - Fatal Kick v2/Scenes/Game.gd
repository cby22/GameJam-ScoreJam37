extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var Car
export(PackedScene) var CarMoving
export(PackedScene) var SpeedBuff
export(PackedScene) var SuperSpeedBuff
export(PackedScene) var Explosion_vfx
export(PackedScene) var Grease

var normal_scale := Vector2.ONE
var scaled_scale := Vector2(0.75, 0.75)

var rng = RandomNumberGenerator.new()

var entity_spawn_locations = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	$Label.visible = true
	$Camera2D/GameOverScreen.visible = false
	$Camera2D/Label.visible = false
	$Camera2D/Leaderboard.visible = false
	entity_spawn_locations.append($Ball.position.y)
	entity_spawn_locations.append($Ball.position.y - 64)
	entity_spawn_locations.append($Ball.position.y + 64)
	scale = scaled_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D/GameOverScreen/Label3.text = str(GlobalVar.score)
	$Camera2D/Label.text = str("SCORE : ", GlobalVar.score)
	if Input.is_action_pressed("ui_accept"):
		# Used ChatGPT for help with how to tween a scale property
		$Label.visible = false
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", normal_scale, 0.5)\
			 .set_trans(Tween.TRANS_QUAD)\
			 .set_ease(Tween.EASE_OUT)
		yield(get_tree().create_timer(1.0), "timeout")
		$Player.frame = 1
		if not GlobalVar.game_start:
			GlobalVar.game_start = true
			print("Game Started")
			$ScoreTimer.start()
			$SlowdownTimer.start()
			$EntityTimer.start()
			$Camera2D/Label.visible = true
	
	# Handle Entity Deletion
	for obstacle in get_tree().get_nodes_in_group("obstacle"):
		if obstacle.position.x < $Camera2D.position.x - 400:
			obstacle.queue_free()
		
		if obstacle.ball_hit_car:
			if not GlobalVar.fireball:
				game_over()
			else:
				GlobalVar.score += 50
				var obstacle_last_location = obstacle.position
				obstacle.queue_free()
				var explode = Explosion_vfx.instance()
				explode.position = obstacle_last_location
				$EntityContainer.add_child(explode)

	for grease in get_tree().get_nodes_in_group("grease"):
		if grease.position.x < $Camera2D.position.x - 400:
			grease.queue_free()

	for speed in get_tree().get_nodes_in_group("speed"):
		if speed.position.x < $Camera2D.position.x - 400:
			speed.queue_free()
		
		if speed.ball_hit_speed:
			GlobalVar.score += 50
			speed.queue_free()
	
	for super_speed in get_tree().get_nodes_in_group("super_speed"):
		if super_speed.position.x < $Camera2D.position.x - 400:
			super_speed.queue_free()
		
		if super_speed.ball_hit_super_speed:
			GlobalVar.score += 100
			$FireballTimer.start()
			super_speed.queue_free()
	
	if $Ball.speed == 0:
		game_over()
	
	if GlobalVar.fireball:
		$EntityTimer.wait_time = 1

func _on_ScoreTimer_timeout():
	print("Incrementing Score")
	if $Ball.speed >= 200:
		GlobalVar.score += 100
	if $Ball.speed > 300:
		GlobalVar.score += 150
	if $Ball.speed > 500:
		GlobalVar.score += 200
	if $Ball.speed > 1000:
		GlobalVar.score += 500

func game_over():
	GlobalVar.game_not_over = false
	$Ball.speed = 0
	$Ball.rotation_speed = 0
	$ScoreTimer.stop()
	$SlowdownTimer.stop()
	$EntityTimer.stop()
	$Camera2D/GameOverScreen.visible = true

# Handle entity spawns
# ____________________________________________________________________________________
# ____________________________________________________________________________________

func spawn_hidden_grease(ball_position_x, amnt):
	var entity_spawn_loc_rolled = entity_spawn_locations[rng.randi_range(0, entity_spawn_locations.size() - 1)]
	var grease_roll = rng.randi_range(0, amnt)
	for i in range(amnt):
		var entity = SpeedBuff.instance()
		if i == grease_roll:
			entity = Grease.instance()
		else:
			entity = SpeedBuff.instance()
		entity.position.x = ball_position_x + 544 + (i * 64)
		entity.position.y = entity_spawn_loc_rolled
		$EntityContainer.add_child(entity)

func spawn_possible_super_speed(ball_position_x, amnt):
	var entity_spawn_loc_rolled = entity_spawn_locations[rng.randi_range(0, entity_spawn_locations.size() - 1)]
	var super_roll = rng.randi_range(0, amnt)
	for i in range(amnt):
		var entity = SpeedBuff.instance()
		if i == super_roll:
			entity = SuperSpeedBuff.instance()
		else:
			entity = SpeedBuff.instance()
		entity.position.x = ball_position_x + 544 + (i * 64)
		entity.position.y = entity_spawn_loc_rolled
		$EntityContainer.add_child(entity)

func spawn_speed(ball_position_x, amnt):
	var entity_spawn_loc_rolled = entity_spawn_locations[rng.randi_range(0, entity_spawn_locations.size() - 1)]
	for i in range(amnt):
		var speed_buff = SpeedBuff.instance()
		speed_buff.position.x = ball_position_x + 544 + (i * 64)
		speed_buff.position.y = entity_spawn_loc_rolled
		$EntityContainer.add_child(speed_buff)

func spawn_cars(ball_position_x, amnt):
	var entity_spawn_loc_rolled = entity_spawn_locations[rng.randi_range(0, entity_spawn_locations.size() - 1)]
	
	for i in range(amnt):
		var car_obstacle = Car.instance()
		car_obstacle.position.x = ball_position_x + 544 + (i * 128)
		car_obstacle.position.y = entity_spawn_loc_rolled
		$EntityContainer.add_child(car_obstacle)

func spawn_moving_car(ball_position_x):
	var entity_spawn_loc_rolled = entity_spawn_locations[rng.randi_range(0, entity_spawn_locations.size() - 1)]
	var car_obstacle = CarMoving.instance()
	car_obstacle.position.x = ball_position_x + 544
	car_obstacle.position.y = entity_spawn_loc_rolled
	$EntityContainer.add_child(car_obstacle)

func spawn_roller(car_rate, move_car_rate, grease_rate, super_rate):
	var roll = rng.randi_range(0, 100)
	if roll < car_rate:
		spawn_cars($Ball.position.x, 1)
	if roll < move_car_rate:
		spawn_moving_car($Ball.position.x)
	elif roll < grease_rate:
		spawn_hidden_grease($Ball.position.x, 5)
	elif roll < super_rate:
		spawn_possible_super_speed($Ball.position.x, 5)
	else:
		spawn_speed($Ball.position.x, 5)

func _on_EntityTimer_timeout():
	if $Ball.speed < 200:
		spawn_roller(20, 40, 60, 65)
	elif $Ball.speed < 400:
		spawn_roller(20, 50, 60, 65)
	elif $Ball.speed < 600:
		spawn_roller(20, 50, 70, 75)
	else:
		spawn_roller(25, 50, 75, 80)

# ____________________________________________________________________________________
# ____________________________________________________________________________________

func _on_SlowdownTimer_timeout():
	var speed_deprecation = 25
	if not GlobalVar.fireball:
		if $Ball.speed < 100:
			$SlowdownTimer.wait_time = 1
			speed_deprecation = 25
		elif $Ball.speed <= 200:
			$SlowdownTimer.wait_time = 5
			speed_deprecation = 25
		elif $Ball.speed < 400:
			$SlowdownTimer.wait_time = 4
			speed_deprecation = 35
		else:
			$SlowdownTimer.wait_time = 1
			speed_deprecation = 50
		$Ball.speed -= speed_deprecation
		print("Losing Speed, now at: ", str($Ball.speed))

func _on_FireballTimer_timeout():
	print("starting slow process")
	GlobalVar.fireball = false
	$EntityTimer.stop()
	$EntityTimer.wait_time = 3
	$Ball.speed = 900
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 800
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 700
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 600
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 500
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 400
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 300
	yield(get_tree().create_timer(0.5), "timeout")
	$Ball.speed = 200
	yield(get_tree().create_timer(1.0), "timeout")
	print("Assured")
	spawn_speed($Ball.position.x, 5)
	$EntityTimer.start()
	$FireballTimer.stop()

# UI Buttons
# ____________________________________________________________________________________
# ____________________________________________________________________________________

func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")

func _on_Retry_pressed():
	GlobalVar.game_start = false
	GlobalVar.game_not_over = true
	get_tree().reload_current_scene()

func _on_Leaderboard_pressed():
	$Camera2D/Leaderboard.visible = true

func _on_Confirm_Button_pressed():
	SavePath.add_new_score($Camera2D/Leaderboard/Leaderboard2.text, GlobalVar.score)
	SavePath.save_leaderboard()

# ____________________________________________________________________________________
# ____________________________________________________________________________________
