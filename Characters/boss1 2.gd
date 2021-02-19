extends KinematicBody2D

var mS=20
var mD=10
var visionrange = 2500
var escaperange=300
var followrange=600
var movespeed= 100
var player = null
var minions3=0
var minions4=0
var minions5=0
var maxminions=3
var maxhp=5000
var hp=maxhp
var dying=0
var dyingtime

var attack1ready=true
var attack1bullets=8
var attack1angular=90
var attack1spd=1.0/1.5
var attack1counting=0

var attack2ready=true
var attack2bullets=20
var attack2angular=360
var attack2spd=0.3/1.5

var attack3bullets=20
var attack3angular=360

var attack4ready=true
var attack4bullets=5
var attack4angular=90
var attack4spd=0.4/1.5

var spawnready=true
var spawncd=3

var movereset=true
var attack1timer=Timer.new()
var attack2timer=Timer.new()
var attack4timer=Timer.new()
var spawntimer=Timer.new()
var movetimer=Timer.new()
var vec_to_player=Vector2()
var randomangle=rand_range(0,6.28)

func _ready():
	add_to_group("bossWizard")
	add_to_group("enemies")
	attack1timer.set_one_shot(true)
	attack1timer.set_wait_time((1/attack1spd))
	attack1timer.connect("timeout",self,"readyattack1")
	add_child(attack1timer)
	attack2timer.set_one_shot(true)
	attack2timer.set_wait_time((1/attack2spd))
	attack2timer.connect("timeout",self,"readyattack2")
	add_child(attack2timer)
	attack4timer.set_one_shot(true)
	attack4timer.set_wait_time((1/attack4spd))
	attack4timer.connect("timeout",self,"readyattack4")
	add_child(attack4timer)
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
	for i in range(20):
		var bullet = preload("res://scenes/boss1Projectile3.tscn").instance()
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

func readyattack2():
	attack2ready=true
	
func readyattack4():
	attack4ready=true
	
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
				var bullet = preload("res://scenes/boss1Projectile1_2.tscn").instance()
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
			var randomRotation=rand_range(0,360)
			for i in range(attack2bullets):
				var bullet = preload("res://scenes/boss1Projectile2.tscn").instance()
#				var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#				bulletStartPosition=bulletStartPosition.normalized()
				bullet.user=global_position
				bullet.target=Vector2(0,-1)
				bullet.position=global_position
				bullet.angleRotation=((i-((attack2bullets-1)/2))*((attack2angular)/(attack2bullets))+randomRotation)
				get_parent().add_child(bullet)
				attack2ready=false
				attack2timer.start()
	if(global_position.distance_to(player.global_position)<visionrange&&player.invisibility==0):
		if(attack4ready):
			var randomRotation=rand_range(-15,15)
			for i in range(attack4bullets):
				var bullet = preload("res://scenes/boss1Projectile4.tscn").instance()
#				var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#				bulletStartPosition=bulletStartPosition.normalized()
				bullet.user=global_position
				bullet.target=player.global_position
				bullet.position=global_position
				bullet.angleRotation=((i-((attack4bullets-1)/2))*((attack4angular)/(attack4bullets-1))+randomRotation)
				get_parent().add_child(bullet)
				attack4ready=false
				attack4timer.start()
	if(global_position.distance_to(player.global_position)<visionrange):
		if(spawnready):
			var randomRotation=rand_range(0,360)
			randomize()
			var minionnumber=randi()%3+3
			if (minionnumber==3&&minions3<maxminions):
				var minion = preload("res://Characters/enemy3.tscn").instance()
				if(global_position.distance_to(player.global_position)>900):
					minion.global_position=global_position-(global_position-player.global_position).normalized()*(global_position.distance_to(player.global_position)-900)
				else:
					minion.global_position=global_position
				minion.rotation_degrees=rotation_degrees
				minion.sScale=mS
				minion.sDeflation=mD
				get_parent().add_child(minion)
				get_tree().call_group("enemies", "set_boss", self)
				minions3+=1
				call_minions()
				spawnready=false
				spawntimer.start()
				$SummonSound.play()
			if (minionnumber==4&&minions4<maxminions):
				var minion = preload("res://Characters/enemy4.tscn").instance()
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
				minions4+=1
				call_minions()
				spawnready=false
				spawntimer.start()
				$SummonSound.play()
			if (minionnumber==5&&minions5<maxminions):
				var minion = preload("res://Characters/enemy5.tscn").instance()
				if(global_position.distance_to(player.global_position)>900):
					minion.global_position=global_position-(global_position-player.global_position).normalized()*(global_position.distance_to(player.global_position)-900)
				else:
					minion.global_position=global_position
				minion.rotation_degrees=rotation_degrees
				minion.sScale=mS
				minion.sDeflation=mD
				get_parent().add_child(minion)
				get_tree().call_group("enemies", "set_boss", self)
				minions5+=1
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

func minions3reduced():
	if(minions3>1):
		minions3-=1

func minions4reduced():
	if(minions4>1):
		minions4-=1

func minions5reduced():
	if(minions5>1):
		minions5-=1

func set_difficulty(d):
	movespeed=movespeed*(0.8+d/2.5)
