extends KinematicBody2D

var mS=20
var mD=10
var visionrange = 3500
var escaperange=300
var followrange=600
var movespeed= 100
var player = null
var minions8=0
var minions9=0
var maxminions=5
var maxhp=5000
var hp=maxhp
var dying=0
var dyingtime

var attack1ready=true
var attack1bullets=12
var attack1angular=180
var attack1spd=1.5/1.5
var attack1counting=0

var attack3bullets=60
var attack3angular=360

var spawnready=true
var spawncd=3

var movereset=true
var attack1timer=Timer.new()
var spawntimer=Timer.new()
var movetimer=Timer.new()
var vec_to_player=Vector2()
var randomangle=rand_range(0,6.28)

func _ready():
	add_to_group("bossGreen")
	add_to_group("enemies")
	attack1timer.set_one_shot(true)
	attack1timer.set_wait_time((1/attack1spd))
	attack1timer.connect("timeout",self,"readyattack1")
	add_child(attack1timer)
	spawntimer.set_one_shot(true)
	spawntimer.set_wait_time(spawncd)
	spawntimer.connect("timeout",self,"readyspawn")
	add_child(spawntimer)
	movetimer.set_one_shot(true)
	movetimer.set_wait_time((0.2))
	movetimer.connect("timeout",self,"move_timeout")
	add_child(movetimer)
	call_minions()

func death():
	print("Enemy dead!")
	var randomRotation=rand_range(0,360)
	for i in range(attack3bullets):
		var bullet = preload("res://scenes/boss1Projectile4.tscn").instance()
		bullet.user=global_position
		bullet.target=player.global_position
		bullet.position=global_position
		bullet.angleRotation=(i-((attack3bullets-1)/2))*(attack3angular/(attack3bullets))+randomRotation
		#bullet.angleRotation=(i-((10-1)/2))*(attack2angular/(attack2bullets-1))
		#bullet.angleRotation=(i)*36
		get_parent().add_child(bullet)
	get_tree().call_group("enemies", "set_boss", null)
	get_parent().get_node("BossMageDeathSound").global_position=global_position
	get_parent().get_node("BossMageDeathSound").play()
	get_parent().lastRoomLeft-=1
	queue_free()

func readyattack1():
	attack1ready=true
	
func readyspawn():
	spawnready=true

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
		if(attack1ready&&attack1counting<2):
			attack1counting+=1
			for i in range(attack1bullets):
				var bullet = preload("res://scenes/boss1Projectile1_1.tscn").instance()
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
		if(attack1ready&&attack1counting==2):
			attack1counting=0
			for i in range(attack1bullets):
				var bullet = preload("res://scenes/boss1Projectile4.tscn").instance()
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
	if(global_position.distance_to(player.global_position)<visionrange):
		if(spawnready):
			var randomRotation=rand_range(0,360)
			randomize()
			var minionnumber=randi()%2+8
			if (minionnumber==8&&minions8<maxminions):
				var minion = preload("res://Characters/enemy8.tscn").instance()
				if(global_position.distance_to(player.global_position)>900):
					minion.global_position=global_position-(global_position-player.global_position).normalized()*(global_position.distance_to(player.global_position)-900)
				else:
					minion.global_position=global_position
				minion.rotation_degrees=rotation_degrees
				minion.sScale=mS
				minion.sDeflation=mD
				#minion.spawnedbyboss=1
				get_parent().add_child(minion)
				get_tree().call_group("enemies", "set_boss", self)
				minions8+=1
				call_minions()
				spawnready=false
				spawntimer.start()
				$SummonSound.play()
			if (minionnumber==9&&minions9<maxminions):
				var minion = preload("res://Characters/enemy9.tscn").instance()
				if(global_position.distance_to(player.global_position)>900):
					minion.global_position=global_position-(global_position-player.global_position).normalized()*(global_position.distance_to(player.global_position)-900)
				else:
					minion.global_position=global_position
				minion.rotation_degrees=rotation_degrees
				minion.sScale=mS
				minion.sDeflation=mD
				get_parent().add_child(minion)
				get_tree().call_group("enemies", "set_boss", self)
				minions9+=1
				call_minions()
				spawnready=false
				spawntimer.start()
				$SummonSound.play()

func _process(delta):
	if(dying==0):
		if hp<=0:
			dying=1
			dyingtime=1
			$deathSound.play()
		else:
			moving(delta)
			shooting()
	elif(dyingtime>0):
		dyingtime-=delta
	else:
		death()

func set_player(p):
	player = p

func call_minions():
	get_tree().call_group("enemies", "set_boss", self)

func minions8reduced():
	if(minions8>1):
		minions8-=1

func minions9reduced():
	if(minions9>1):
		minions9-=1

func set_difficulty(d):
	movespeed=movespeed*(0.8+d/2.5)
