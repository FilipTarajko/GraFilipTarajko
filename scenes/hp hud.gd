extends TextureProgress

var scale_x=15
var scale_y=10
var def_x=-0.25
var def_y=0.36

func _ready():
	rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
	rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom
	max_value=get_parent().get_parent().maxmp
	value=get_parent().get_parent().mp

func _process(_delta):
	#rect_position=Vector2(-500,700)
	rect_position=Vector2(def_x*get_viewport().size.x,def_y*get_viewport().size.y)*get_parent().zoom
	rect_scale=Vector2(scale_x*get_viewport().size.x/1920,scale_y*get_viewport().size.y/1080)*get_parent().zoom
	max_value=get_parent().get_parent().maxhp
	value=get_parent().get_parent().hp
