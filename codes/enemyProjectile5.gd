extends Area2D

var weaponrange=750
var damage=50
var speed =500

var angleRotation=0
var user=Vector2()
var velocity = Vector2()
var target=Vector2()

func _ready():
	rotation=((target - user).normalized()).rotated(deg2rad(angleRotation+90)).angle()
	velocity = ((target - user).normalized()).rotated(deg2rad(angleRotation)) * speed

func _physics_process(delta):
	if (global_position.distance_to(user)>weaponrange):
		get_parent().remove_child(self)
	position = position+(velocity)*delta

func _on_Area2D_body_enter(body):
	print("1")
	if body.is_in_group("players"):
		print(str('Player has entered'))

func _on_KinematicBody2D_body_entered(body):
	if body.is_in_group("players"):
		body.hp-=damage
		body.burn(2.0)
		print(("Player has ")+str(body.hp)+"hp!")
