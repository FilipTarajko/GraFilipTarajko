extends Area2D

func _ready():
		modulate=Color(0,0,0);
		scale=Vector2(20,32)

func _on_Portal_body_entered(body):
	if body.is_in_group("players"):
		print("Portal teleportuje do"+str(0)+","+str(14336))
		body.position.x=0
		body.position.y=14336
		get_parent().running=false
		body.nextLevel()

func _physics_process(delta):
	if(get_parent().lastRoomLeft==0):
		global_position=Vector2(16768,8704)
