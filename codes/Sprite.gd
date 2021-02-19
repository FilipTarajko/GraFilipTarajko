extends Sprite

var direction
var d = {
	wizFront=preload("res://graphics/sorcerer_blue.png"),
	wizBack=preload("res://graphics/sorcerer_blueBack.png"),
	wizLeft=preload("res://graphics/sorcerer_blueLeft.png"),
	wizRight=preload("res://graphics/sorcerer_blueRight.png"),
	archFront=preload("res://graphics/archerGreen.png"),
	archBack=preload("res://graphics/archerGreenBack.png"),
	archLeft=preload("res://graphics/archerGreenLeft.png"),
	archRight=preload("res://graphics/archerGreenRight.png"),
}

func _ready():
	direction="Front"

func _process(_delta):
	if Input.is_action_pressed("moveleft"):
		direction="Left"
	if Input.is_action_pressed("moveright"):
		direction="Right"
	if Input.is_action_pressed("moveup"):
		direction="Back"
	if Input.is_action_pressed("movedown"):
		direction="Front"
	var usedCharacter=null
	if(get_parent().character=="Wizard"):
		usedCharacter="wiz"
	else:
		usedCharacter="arch"
	#var character=get_parent().character
	var result=(str(usedCharacter)+str(direction))
	texture=d[result]

#var wizFront=preload("res://graphics/sorcerer_blue.png")
#var wizBack=preload("res://graphics/sorcerer_blueBack.png")
#var wizLeft=preload("res://graphics/sorcerer_blueLeft.png")
#var wizRight=preload("res://graphics/sorcerer_blueRight.png")
#var archFront=preload("res://graphics/archerGreen.png")
#var archBack=preload("res://graphics/archerGreenBack.png")
#var archLeft=preload("res://graphics/archerGreenLeft.png")
#var archRight=preload("res://graphics/archerGreenRight.png")

#func _process(delta):
#	if(Input.is_action_just_pressed("change_character")):
#		if(get_parent().character=="Wizard"):
#			texture=wizFront
#		if(get_parent().character=="Archer"):
#			texture=archFront
#	if(get_parent().character=="Wizard"):
#		if Input.is_action_pressed("moveleft"):
#			texture=wizLeft
#		if Input.is_action_pressed("moveright"):
#			texture=wizRight
#		if Input.is_action_pressed("moveup"):
#			texture=wizBack
#		if Input.is_action_pressed("movedown"):
#			texture=wizFront
#	if(get_parent().character=="Archer"):
#		if Input.is_action_pressed("moveleft"):
#			texture=archLeft
#		if Input.is_action_pressed("moveright"):
#			texture=archRight
#		if Input.is_action_pressed("moveup"):
#			texture=archBack
#		if Input.is_action_pressed("movedown"):
#			texture=archFront
