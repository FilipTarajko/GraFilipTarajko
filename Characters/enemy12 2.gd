extends KinematicBody2D

var protectors=2
var sScale=10
var sDeflation
var visionrange = 1500
var escaperange=0
var followrange=0
var movespeed= 300
var player = null
var boss=null
var maxhp=3500
var hp=maxhp

var attack1ready=true
var attack1bullets=3
var attack1angular=15
var attack1spd=5.0

var attack2ready=true
var attack2bullets=18
var attack2angular=360
var attack2spd=5.0

var movereset=true
var attack1timer=Timer.new()
var attack2timer=Timer.new()
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
	attack2timer.set_one_shot(true)
	attack2timer.set_wait_time((1/attack2spd))
	attack2timer.connect("timeout",self,"readyattack2")
	add_child(attack2timer)
	movetimer.set_one_shot(true)
	movetimer.set_wait_time((0.2))
	movetimer.connect("timeout",self,"move_timeout")
	add_child(movetimer)

func death():
	print("Enemy dead!")
	for i in range(attack2bullets):
		var bullet = preload("res://scenes/enemy10Projectile2.tscn").instance()
		bullet.scale=Vector2(6,3)
		bullet.user=global_position
		bullet.target=Vector2(0,-1)
		bullet.position=global_position
		bullet.angleRotation=(i-((attack2bullets-1)/2))*((attack2angular)/(attack2bullets))
		get_parent().add_child(bullet)
	get_parent().lastRoomLeft-=1
	queue_free()

func readyattack1():
	attack1ready=true

func readyattack2():
	attack2ready=true

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
				var bullet = preload("res://scenes/enemy12Projectile1.tscn").instance()
#				var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#				bulletStartPosition=bulletStartPosition.normalized()
				bullet.user=global_position
				bullet.target=player.global_position
				bullet.position=global_position
#				i-((attack2bullets-1)/2)*(attack2angular/attackbult-1
				bullet.angleRotation=(i-((attack1bullets-1)/2))*(attack1angular/(attack1bullets-1))
				get_parent().add_child(bullet)
				attack1ready=false
				attack1timer.start()
	if(global_position.distance_to(player.global_position)<player.visionrange):
		if(attack2ready):
			for i in range(attack2bullets):
				var bullet = preload("res://scenes/enemy10Projectile2.tscn").instance()
#				var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#				bulletStartPosition=bulletStartPosition.normalized()
				bullet.user=global_position
				bullet.target=Vector2(0,-1)
				bullet.position=global_position
				bullet.angleRotation=(i-((attack2bullets-1)/2))*((attack2angular)/(attack2bullets))
				get_parent().add_child(bullet)
				attack2ready=false
				attack2timer.start()

func _process(delta):
	if (hp<=0&&protectors==0):
		death()
	if(protectors>0):
		$TextureProgress.modulate.a=0.0
		hp=maxhp
	else:
		$TextureProgress.modulate.a=1.0
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
