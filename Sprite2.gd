extends Sprite

var whirlSpeed=-1500

func _process(delta):
	rotation_degrees=rotation_degrees+delta*whirlSpeed
