extends Area2D

#func _ready():
#	add_to_group("portals")

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(position.x-2048)+","+str(position.y+4480))
		body.position.y=position.y+4480
		body.position.x=position.x-2048
		body.nextLevel()

#func set_difficulty(d):
#	if(d==0):
#		modulate=Color(0,1,0);
#	if(d==2):
#		modulate=Color(1,0,0);
