extends Area2D

var gracza=Vector2()
var speed = 1000
var velocity = Vector2()
var weaponrange=450
var target=Vector2()

func _ready():
	velocity = ((target.global_position - gracza).normalized()).rotated(deg2rad(rotation)) * speed

func _physics_process(delta):
	if (global_position.distance_to(gracza)>weaponrange):
		get_parent().remove_child(self)
	position = position+(velocity)*delta

func _on_Area2D_body_enter(body):
	print("1")
	if body.is_in_group("players"):
		print(str('Player has entered'))

func _on_KinematicBody2D_body_entered(body):
	if body.is_in_group("players"):
		body.hp-=100
		print(("Player has ")+str(body.hp)+"hp!")
