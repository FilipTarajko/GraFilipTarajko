extends TextureProgress

var scale_x=10
var scale_y=10
var def_x=0.025
var def_y=-0.45

func _ready():
	rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
	rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom

func _process(_delta):
	#rect_position=Vector2(-500,700)
	rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
	rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom
	max_value=get_parent().get_parent().paralyzetimer.wait_time*100
	value=get_parent().get_parent().paralyzetimer.time_left*100
