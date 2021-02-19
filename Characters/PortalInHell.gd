extends Area2D

#func _ready():
#	add_to_group("portals")

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(position.x-3328)+","+str(position.y+6144))
		body.position.y=position.y+6144
		body.position.x=position.x-3328
		body.nextLevel()
