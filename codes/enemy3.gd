extends KinematicBody2D

var sScale=10
var sDeflation
var visionrange = 1500
var movespeed= 500
var player = null
var boss=null
var maxhp=250
var hp=maxhp
var attspd=2.0
var ready=true
var timer=Timer.new()

func _ready():
	$Sprite.scale=Vector2(sScale,sScale)
	add_to_group("enemies")
	get_tree().call_group("players", "callEnemies")
	timer.set_one_shot(true)
	timer.set_wait_time((1/attspd))
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)

func death():
	print("Enemy dead!")
	for i in range(30):
		var bullet = preload("res://scenes/enemyProjectile3.tscn").instance()
		bullet.gracza=global_position
		bullet.target=player
		bullet.position=global_position
		bullet.rotation=(i)*12
		get_parent().add_child(bullet)
	get_tree().call_group("bossWizard", "minions3reduced")
	queue_free()

func on_timeout():
	ready=true

func _process(delta):
	if hp<=0:
		death()
	if($Sprite.scale.x>10):
		$Sprite.scale=Vector2($Sprite.scale.x-sDeflation*delta,$Sprite.scale.y-sDeflation*delta)
	if Input.is_action_pressed("rotateleft"):
		rotation_degrees-=player.rotationspeed*delta
	if Input.is_action_pressed("rotateright"):
		rotation_degrees+=player.rotationspeed*delta
	if Input.is_action_just_pressed("resetrotation"):
		rotation_degrees=0
#	if player == null:
#		return
	if(global_position.distance_to(player.global_position)<visionrange&&player.invisibility==0):
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * movespeed * delta)
	if (global_position.distance_to(player.global_position)<visionrange&&ready&&player.invisibility==0):
		for i in range(5):
			var bullet = preload("res://scenes/enemyProjectile3.tscn").instance()
#			var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#			bulletStartPosition=bulletStartPosition.normalized()
			bullet.gracza=global_position
			bullet.target=player
			bullet.position=global_position
			bullet.rotation=(i-2)*12
			get_parent().add_child(bullet)
			ready=false
			timer.start()

func set_player(p):
	player = p

func set_boss(b):
	boss = b

func set_difficulty(d):
	movespeed=movespeed*(0.8+d/2.5)
