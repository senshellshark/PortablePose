class_name ImageItem
extends Resource

export var image_source : String
var image_texture : ImageTexture

func load_texture(source : String = ""):
	if not image_texture == null:
		return 0
	if source == "" and image_source == "":
		print("Warning: attempt to load texture with no source path.")
		return 1
	image_source = image_source if source == "" else source
	var img = Image.new()
	var e = img.load(image_source)
	if e == 0:
		var tex = ImageTexture.new()
		tex.create_from_image(img)
		image_texture = tex
	return e
