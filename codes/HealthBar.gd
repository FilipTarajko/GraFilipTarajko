extends TextureProgress

func _process(_delta):
	max_value=get_parent().maxhp
	value=get_parent().hp
