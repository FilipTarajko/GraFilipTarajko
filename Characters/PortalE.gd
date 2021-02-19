extends Area2D

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(-15104)+","+str(-8064))
		body.position.y=-8064
		body.position.x=-15104
		get_parent().difficultyLevel=0
		get_parent().difficulty="Easy"
		get_parent().running=true
		get_parent().started=true
		body.maxhp=800
		get_tree().call_group("enemies", "set_difficulty", 0)
		body.weapondamage=(1.5)*body.weapondamage
		get_parent().time=0.0
		print(get_parent().difficultyLevel)
		body.nextLevel()
