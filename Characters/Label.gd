extends Label

var scale_x=1
var scale_y=1
var def_x=-0.48
var def_y=-0.48

func _ready():
	rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
	rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom

func _process(_delta):
	if(get_parent().get_parent().get_parent().running):
		text=get_parent().get_parent().get_parent().difficulty+" - "+str(round(1000*get_parent().get_parent().get_parent().time)/1000)
	if(get_parent().get_parent().get_parent().started):
		rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
		rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom
