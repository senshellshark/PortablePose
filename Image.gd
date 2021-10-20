extends TextureRect

var is_dupe = false

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Image_gui_input(event):
	if !is_dupe:
		if event is InputEventMouseButton and event.doubleclick:
			get_parent().preview(self)
