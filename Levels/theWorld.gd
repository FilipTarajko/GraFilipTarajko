extends Node2D

var difficulty="Normal"
var difficultyLevel=1
var lastRoomLeft=3
var time=0.0
var running=false
var started=false

func _physics_process(delta):
	time+=delta
