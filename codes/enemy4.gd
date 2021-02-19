extends KinematicBody2D

var sScale=10
var sDeflation
var visionrange = 1500
var escaperange=300
var followrange=500
var movespeed= 300
var player = null
var boss = null
var maxhp=150
var hp=maxhp
var attspd=1.0
var ready=true
var movereset=true
var timer=Timer.new()
var movetimer=Timer.new()
var vec_to_player=Vector2()
var randomangle=rand_range(0,6.28)

func _ready():
	$Sprite.scale=Vector2(sScale,sScale)
	add_to_group("enemies")
	get_tree().call_group("players", "callEnemies")
	timer.set_one_shot(true)
	timer.set_wait_time((1/attspd))
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)
	movetimer.set_one_shot(true)
	movetimer.set_wait_time((0.2))
	movetimer.connect("timeout",self,"move_timeout")
	add_child(movetimer)

func death():
	print("Enemy dead!")
	for i in range(5):
		var bullet = preload("res://scenes/enemyProjectile4.tscn").instance()
		bullet.gracza=global_position
		bullet.target=player
		bullet.position=global_position
		bullet.rotation=(i)*72
		get_parent().add_child(bullet)
	get_tree().call_group("bossWizard", "minions4reduced")
	queue_free()

func on_timeout():
	ready=true

func move_timeout():
	print("movetimeout")
	randomangle=rand_range(0,6.28)
	movetimer.set_wait_time(rand_range(0.05,0.8))
	movereset=true

func moving(delta):
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	if(global_position.distance_to(player.global_position)<visionrange&&global_position.distance_to(player.global_position)<escaperange&&player.invisibility==0):
		move_and_collide(-vec_to_player * movespeed * delta)
	elif(global_position.distance_to(player.global_position)<visionrange&&global_position.distance_to(player.global_position)>followrange&&player.invisibility==0):
		move_and_collide(vec_to_player * movespeed * delta)
	else:
		if(global_position.distance_to(player.global_position)<visionrange):
			if(movereset==true):
				movereset=false
				print(randomangle)
				movetimer.start()
			move_and_collide((vec_to_player.rotated(randomangle)* movespeed * delta))
	if Input.is_action_pressed("rotateleft"):
		rotation_degrees-=player.rotationspeed*delta
	if Input.is_action_pressed("rotateright"):
		rotation_degrees+=player.rotationspeed*delta
	if Input.is_action_just_pressed("resetrotation"):
		rotation_degrees=0

func shooting():
	if (global_position.distance_to(player.global_position)<visionrange&&ready&&player.invisibility==0):
		for i in range(3):
			var bullet = preload("res://scenes/enemyProjectile4.tscn").instance()
#			var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#			bulletStartPosition=bulletStartPosition.normalized()
			bullet.gracza=global_position
			bullet.target=player
			bullet.position=global_position
			bullet.rotation=(i-1)*20
			get_parent().add_child(bullet)
			ready=false
			timer.start()

func _process(delta):
	if hp<=0:
		death()
	if($Sprite.scale.x>10):
		$Sprite.scale=Vector2($Sprite.scale.x-sDeflation*delta,$Sprite.scale.y-sDeflation*delta)
#	if player == null:
#		return
	moving(delta)
	shooting()

func set_player(p):
	player = p

func set_boss(b):
	boss = b

func set_difficulty(d):
	movespeed=movespeed*(0.8+d/2.5)
