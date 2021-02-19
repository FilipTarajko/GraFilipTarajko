extends Area2D

func _ready():
		modulate=Color(1,0,0);
		scale=Vector2(10,16)

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(14080)+","+str(-5120))
		body.position.x=14080
		body.position.y=-5120
		body.nextLevel()
