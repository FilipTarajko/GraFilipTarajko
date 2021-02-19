extends Area2D

func _ready():
		modulate=Color(0,0,0);
		scale=Vector2(10,16)

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(0)+","+str(0))
		body.position.x=0
		body.position.y=0
		body.nextLevel()
