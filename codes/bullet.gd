extends Area2D

var user=Vector2()
var velocity = Vector2()
var damage
var sprite
var speed
var weaponrange
var angleRotation
var blueOrb=preload("res://graphics/playerbullet.png")
var woodenArrow=preload("res://graphics/WoodenArrowGreen.png")

func _ready():
	if(sprite=="Wizard"):
		$Sprite.texture=blueOrb
		scale=Vector2(2,2)
		$Shape.scale.x=2
	if(sprite=="Archer"):
		scale=Vector2(4,4)
		$Sprite.texture=woodenArrow
	velocity = ((get_global_mouse_position()- user).normalized()).rotated(deg2rad(angleRotation)) * speed
	#velocity = (get_global_mouse_position() - user).normalized() * speed
	rotation=((get_global_mouse_position() - user).normalized()).rotated(deg2rad(angleRotation+90)).angle()

func _physics_process(delta):
	if (global_position.distance_to(user)>weaponrange):
		get_parent().remove_child(self)
	position = position+(velocity)*delta

func _on_Area2D_body_enter(body):
	print("1")
	if body.is_in_group("enemies"):
		print(str('Enemy has entered'))

func _on_KinematicBody2D_body_entered(body):
	if body.is_in_group("enemies"):
		body.hp-=damage
#		print(("Enemy has ")+str(body.hp)+"hp!")
