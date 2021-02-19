extends KinematicBody2D

var rotationSpeed=180
var sScale=10
var sDeflation
var visionrange = 1500
var player = null
var boss=null
var maxhp=1000
var hp=maxhp

var attack1ready=true
var attack1bullets=3
var attack1angular=30
var attack1spd=1.0

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
	movetimer.set_one_shot(true)
	movetimer.set_wait_time((0.2))
	movetimer.connect("timeout",self,"move_timeout")
	add_child(movetimer)

func death():
	get_parent().get_parent().protectors-=1
	print("Enemy dead!")
	queue_free()

func readyattack1():
	attack1ready=true

func move_timeout():
#	print("movetimeout")
	randomangle=rand_range(0,6.28)
	movetimer.set_wait_time(rand_range(0.05,0.8))
	movereset=true

func moving(delta):
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
				var bullet = preload("res://scenes/enemy13Projectile1.tscn").instance()
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

func _process(delta):
	rotation_degrees=rotation_degrees+delta*rotationSpeed
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
