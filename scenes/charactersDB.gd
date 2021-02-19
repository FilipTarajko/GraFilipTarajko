extends Node
 
var movespeed
var maxhp
var hpregen
var maxmp
var mpregen
var weaponspeed
var weaponrange
var attspd
var bullets
var angular
var abilitycooldown
var invisibilitytime
var abilitymanacost



const CHARACTERS = {
	"Wizard": {
		movespeed=600,
		maxhp=500,
		hpregen=30,
		maxmp=100,
		mpregen=5,
		weaponspeed=1200,
		weaponrange=500,
		attspd=4.0,
		bullets=3,
		angular=30,
		abilitycooldown=5.0,
		invisibilitytime=2,
		abilitymanacost=50,
	},
	"Archer": {
		movespeed=600,
		maxhp=500,
		hpregen=30,
		maxmp=100,
		mpregen=5,
		weaponspeed=1200,
		weaponrange=500,
		attspd=4.0,
		bullets=3,
		angular=30,
		abilitycooldown=5.0,
		invisibilitytime=2,
		abilitymanacost=50,
	}
}


func get_character(char_id):
	if char_id in CHARACTERS:
		return CHARACTERS[char_id]
	else:
		return CHARACTERS["error"]
