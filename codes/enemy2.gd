extends KinematicBody2D

var visionrange = 800
var escaperange=400
var followrange=600
var movespeed= 300
var player = null
var maxhp=200
var hp=maxhp
var attspd=1.0
var ready=true
var timer=Timer.new()

func _ready():
	add_to_group("enemies")
	timer.set_one_shot(true)
	timer.set_wait_time((1/attspd))
	timer.connect("timeout",self,"on_timeout")
	add_child(timer)

func on_timeout():
	ready=true

func _process(delta):
	if hp<=0:
		print("Enemy dead!")
		queue_free()
	if Input.is_action_pressed("rotateleft"):
		rotation_degrees-=player.rotationspeed*delta
	if Input.is_action_pressed("rotateright"):
		rotation_degrees+=player.rotationspeed*delta
	if Input.is_action_just_pressed("resetrotation"):
		rotation_degrees=0
#	if player == null:
#		return
	if(global_position.distance_to(player.global_position)<visionrange&&global_position.distance_to(player.global_position)<escaperange&&player.invisibility==0):
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(-vec_to_player * movespeed * delta)
	elif(global_position.distance_to(player.global_position)<visionrange&&global_position.distance_to(player.global_position)>followrange&&player.invisibility==0):
		var vec_to_player = player.global_position - global_position
		vec_to_player = vec_to_player.normalized()
		move_and_collide(vec_to_player * movespeed * delta)
	if (global_position.distance_to(player.global_position)<visionrange&&ready&&player.invisibility==0):
		var bullet = preload("res://scenes/enemyProjectile2.tscn").instance()
#		var bulletStartPosition=Vector2((player.global_position.x-global_position.x),(player.global_position.y-global_position.y))
#		bulletStartPosition=bulletStartPosition.normalized()
		bullet.gracza=global_position
		bullet.target=player
		bullet.position=global_position
		get_parent().add_child(bullet)
		ready=false
		timer.start()

func set_player(p):
	player = p
