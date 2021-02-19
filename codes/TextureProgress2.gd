extends TextureProgress

func _ready():
	max_value=get_parent().maxmp
	value=get_parent().mp

func _process(_delta):
	max_value=get_parent().maxmp
	value=get_parent().mp
