extends Node2D

var rotationSpeed=-180

func _process(delta):
	rotation_degrees=rotation_degrees+delta*rotationSpeed
