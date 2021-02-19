#extends Sprite
#
#var sprite=get_parent().sprite
#var blueOrb=preload("res://graphics/playerbullet.png")
#var woodenArrow=preload("res://graphics/WoodenArrowGreen.png")
#
#func _physics_process(delta):
#	if(sprite=="Wizard"):
#		texture=blueOrb
#	if(sprite=="Archer"):
#		texture=woodenArrow