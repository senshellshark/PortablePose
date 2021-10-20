extends GridContainer

signal preview_image

func _ready():
	resize()
	get_tree().get_root().connect("size_changed", self, "resize")

func resize():
	set_columns(int(get_parent().get_rect().size.x / 170.0))

func preview(image):
	emit_signal("preview_image", image)
