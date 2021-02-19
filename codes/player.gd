extends KinematicBody2D

var rotationspeed=rad2deg(4)
var visionrange=3000

var character

var movespeed
var maxhp=500
var hpregen=30
var maxmp=100
var mpregen=5

var audio

var weapondamage
var weaponspeed
var weaponrange
var attspd
var bullets
var angular

var abilitycooldown=5.0
var invisibilitytime=2
var abilitymanacost=50

var move_vec=Vector2()
var hp=maxhp
var mp=maxmp
var attackready=true
var attacktimer=Timer.new()
var abilityready=true
var abilitytimer=Timer.new()
var invisibilitytimer=Timer.new()
var invisibility=0
var slowtimer=Timer.new()
var slowed=0
var burntimer=Timer.new()
var burning=0
var bleedtimer=Timer.new()
var bleeding=0
var paralyzetimer=Timer.new()
var paralyzed=0

func _ready():
	changeChar()
	attacktimer.set_one_shot(true)
	attacktimer.set_wait_time((1/attspd))
	attacktimer.connect("timeout",self,"on_attacktimeout")
	add_child(attacktimer)
	
	abilitytimer.set_one_shot(true)
	abilitytimer.set_wait_time(abilitycooldown)
	abilitytimer.connect("timeout",self,"on_abilitytimeout")
	add_child(abilitytimer)
	
	invisibilitytimer.set_one_shot(true)
	invisibilitytimer.set_wait_time(invisibilitytime)
	invisibilitytimer.connect("timeout",self,"on_invisibilitytimeout")
	add_child(invisibilitytimer)
	
	slowtimer.set_one_shot(true)
	slowtimer.connect("timeout",self,"on_slowtimeout")
	add_child(slowtimer)
	
	burntimer.set_one_shot(true)
	burntimer.connect("timeout",self,"on_burntimeout")
	add_child(burntimer)
	
	bleedtimer.set_one_shot(true)
	bleedtimer.connect("timeout",self,"on_bleedtimeout")
	add_child(bleedtimer)
	
	paralyzetimer.set_one_shot(true)
	paralyzetimer.connect("timeout",self,"on_paralyzetimeout")
	add_child(paralyzetimer)
	
	add_to_group("players")
	yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)

func on_attacktimeout():
	attackready=true

func on_abilitytimeout():
	print("Ability ready")
	get_node("mp").modulate.a=1
	get_node("Camera2D").get_node("mp hud").modulate.a=1
	abilityready=true

func on_invisibilitytimeout():
	get_node("Sprite").modulate.a=1
	invisibility=0

func on_abilityuse():
	mp=mp-abilitymanacost
	get_node("Sprite").modulate.a=0.3
	get_node("mp").modulate.a=0.3
	get_node("Camera2D").get_node("mp hud").modulate.a=0.3
	print("Ability has been used")
	abilityready=false
	abilitytimer.start()
	invisibilitytimer.start()
	invisibility=1
	$invisibilitySound.play()

func slow(slowduration):
	if slowed==0:
		slowed=1
		slowtimer.set_wait_time(slowduration*(2+get_parent().difficultyLevel)/3)
		slowtimer.start()
	else:
		if(slowtimer.time_left<slowduration*(2+get_parent().difficultyLevel)/3):
			slowed=1
			slowtimer.set_wait_time(slowduration*(2+get_parent().difficultyLevel)/3)
			slowtimer.start()

func on_slowtimeout():
	slowed=0

func burn(burnduration):
	if burning==0:
		burning=1
		burntimer.set_wait_time(burnduration)
		burntimer.start()
	else:
		if(burntimer.time_left<burnduration):
			burning=1
			burntimer.set_wait_time(burnduration)
			burntimer.start()

func on_burntimeout():
	burning=0

func bleed(bleedduration):
	if bleeding==0:
		bleeding=1
		bleedtimer.set_wait_time(bleedduration)
		bleedtimer.start()
	else:
		if(bleedtimer.time_left<bleedduration):
			bleeding=1
			bleedtimer.set_wait_time(bleedduration)
			bleedtimer.start()

func on_bleedtimeout():
	bleeding=0
	
func paralyze(paralyzeduration):
	if paralyzed==0:
		paralyzed=1
		paralyzetimer.set_wait_time(paralyzeduration*(2+get_parent().difficultyLevel)/3)
		paralyzetimer.start()
	else:
		if(paralyzetimer.time_left<paralyzeduration*(2+get_parent().difficultyLevel)/3):
			paralyzed=1
			paralyzetimer.set_wait_time(paralyzeduration*(2+get_parent().difficultyLevel)/3)
			paralyzetimer.start()

func on_paralyzetimeout():
	paralyzed=0

func moving(delta):
	move_vec=Vector2()
	if Input.is_action_pressed("moveup"):
		move_vec.y-=1
	if Input.is_action_pressed("movedown"):
		move_vec.y+=1
	if Input.is_action_pressed("moveleft"):
		move_vec.x-=1
	if Input.is_action_pressed("moveright"):
		move_vec.x+=1
	if Input.is_action_pressed("rotateleft"):
		rotation_degrees-=rotationspeed*delta
	if Input.is_action_pressed("rotateright"):
		rotation_degrees+=rotationspeed*delta
	if Input.is_action_just_pressed("resetrotation"):
		rotation_degrees=0
	move_vec=move_vec.normalized().rotated(rotation)
	if(paralyzed==0):
		move_and_collide((move_vec*movespeed*delta)/(1+slowed))

func shooting():
#	var look_vec = get_global_mouse_position() - global_position
	if (Input.is_action_pressed("shoot")&&attackready):
		if(character=="Wizard"):
			$magicSound.play()
		if(character=="Archer"):
			$bowSound.play()
		for i in range(bullets):
			var bullet = preload("res://scenes/projectile.tscn").instance()
#			var bulletStartPosition=Vector2((get_global_mouse_position().x-global_position.x),(get_global_mouse_position().y-global_position.y))
#			bulletStartPosition=bulletStartPosition.normalized()
			bullet.angleRotation=(i-((bullets-1)/2))*((angular)/(bullets))
			bullet.sprite=character
			bullet.user=global_position
			bullet.damage=weapondamage
			bullet.speed=weaponspeed
			bullet.weaponrange=weaponrange
			bullet.position=global_position
			get_parent().add_child(bullet)
			attackready=false
			attacktimer.start()

func changeChar():
		if(character=="Wizard"):
			character="Archer"
			movespeed=700
			weapondamage=100*(1.5-get_parent().difficultyLevel/2)
			weaponrange=700
			weaponspeed=1500
			attspd=3.0
			attacktimer.set_wait_time((1/attspd))
			bullets=1
			angular=0
		else:
			character="Wizard"
			movespeed=500
			weapondamage=50*(1.5-get_parent().difficultyLevel/2)
			weaponrange=500
			weaponspeed=1000
			attspd=5.0
			attacktimer.set_wait_time((1/attspd))
			bullets=5
			angular=30

func nextLevel():
	hp=maxhp
	mp=maxmp
	slowtimer.stop()
	abilitytimer.stop()
	invisibilitytimer.stop()
	burntimer.stop()
	bleedtimer.stop()
	paralyzetimer.stop()
	on_slowtimeout()
	on_abilitytimeout()
	on_invisibilitytimeout()
	on_burntimeout()
	on_bleedtimeout()
	on_paralyzetimeout()
	get_node("invisibilitySound").stop()

func _process(delta):
	if(abilityready&&mp>=abilitymanacost):
		get_node("mp").modulate.a=1
		get_node("Camera2D").get_node("mp hud").modulate.a=1
	else:
		get_node("mp").modulate.a=0.3
		get_node("Camera2D").get_node("mp hud").modulate.a=0.3
	if(Input.is_action_just_pressed("change_character")):
		changeChar()
	moving(delta)
	shooting()
	if Input.is_action_just_pressed("reset"):
		get_tree().change_scene("res://Levels/theWorld.tscn")
	if hp<=0:
		print("Player dead!")
		get_tree().change_scene("res://Levels/theWorld.tscn")
#	if(atan2(look_vec.y,look_vec.x)>-1.57&&atan2(look_vec.y,look_vec.x)<1.57):
#		global_rotation=atan2(look_vec.y,look_vec.x)
#	else:
#		global_rotation=atan2(look_vec.y,look_vec.x)-3.14
	if(burning==1):
		hp-=(20*get_parent().difficultyLevel+70)*delta
	if(bleeding==1):
		hp-=(20*get_parent().difficultyLevel+60)*delta
	hp=min(hp+hpregen*delta*(2-get_parent().difficultyLevel),maxhp)
	mp=min(mp+mpregen*delta*(2-get_parent().difficultyLevel),maxmp)
	if (Input.is_action_pressed("ability")&&abilityready&&mp>=abilitymanacost):
		on_abilityuse()
#	if (Input.is_action_just_pressed("mute")):
#		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)

func callEnemies():
	get_tree().call_group("enemies", "set_player", self)
