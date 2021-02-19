extends Camera2D

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	OS.set_window_size(Vector2(OS.get_window_size().x,OS.get_window_size().x*9/16))
	zoom=Vector2(2560/OS.get_window_size().x,1440/OS.get_window_size().y)