extends KinematicBody2D

var sScale=10
var sDeflation
var visionrange = 1500
var escaperange=0
var followrange=0
var movespeed= 100
var player = null
var boss=null
var maxhp=500
var hp=maxhp

var attack1ready=true
var attack1bullets=1
var attack1angular=30
var attack1spd=1.2

#var attack2bullets=24

var movereset=true
var attack1timer=Timer.new()
var movetimer=Timer.new()
var vec_to_player=Vector2()
var randomangle=rand_range(0,6.28)

func _ready():
	$Sprite.scale=Vector2(sScale,sScale)
	add_to_group("enemies")
	get_tree().call_group("players", "callEnemies")
	attack1timer.set_one_shot(true)
	attack1timer.set_wait_time((1/attack1spd))
	attack1timer.connect("timeout",self,"readyattack1")
	add_child(attack1timer)
	movetimer.set_one_shot(true)
	movetimer.set_wait_time((0.2))
	movetimer.connect("timeout",self,"move_timeout")
	add_child(movetimer)

func death():
	print("Enemy dead!")
#	for i in range(attack2bullets):
#		var bullet = preload("res://scenes/enemy6Projectile1.tscn").instance()
#		bullet.user=global_position
#		bullet.target=player.global_position
#		bullet.position=global_position
#		bullet.angleRotation=(i-((attack2bullets-1)/2))*(360/(attack2bullets-1))
#		#bullet.angleRotation=(i-((10-1)/2))*(attack2angular/(attack2bullets-1))
#		#bullet.angleRotation=(i)*36
#		get_parent().add_child(bullet)
	get_tree().call_group("bossGreen", "minions8reduced")
	queue_free()

func readyattack1():
	attack1ready=true

func move_timeout():
#	print("movetimeout")
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
#				print(randomangle)
				movetimer.start()
			move_and_collide((vec_to_player.rotated(randomangle)* movespeed * delta))
	if Input.is_action_pressed("rotateleft"):
		rotation_degrees-=player.rotationspeed*delta
	if Input.is_action_pressed("rotateright"):
		rotation_degrees+=player.rotationspeed*delta
	if Input.is_action_just_pressed("resetrotation"):
		rotation_degrees=0

func shooting():
	if (global_position.distance_to(player.global_position)<visionrange&&player.invisibility==0):
		if(attack1ready):
			for i in range(attack1bullets):
				var randomRotation=rand_range(-4,4)
				var bullet = preload("res://scenes/enemy8Projectile1.tscn").instance()
#				var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#				bulletStartPosition=bulletStartPosition.normalized()
				bullet.user=global_position
				bullet.target=player.global_position
				bullet.position=global_position
#				i-((attack2bullets-1)/2)*(attack2angular/attackbult-1
				bullet.angleRotation=(i-((attack1bullets-1)/2))*(attack1angular)+randomRotation#/(attack1bullets-1))
				get_parent().add_child(bullet)
				attack1ready=false
				attack1timer.start()

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
