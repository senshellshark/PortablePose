extends MenuButton

var image_item : ImageItem setget set_image_item


func _ready():
	var popup = get_popup()
	var _err = popup.connect("id_pressed", self, "_on_id_pressed")


func _on_id_pressed(id: int):
	var label = get_popup().get_item_text(id)
	match label:
		"Remove":
			remove()


func set_image_item(_image_item):
	image_item = _image_item
	if image_item.image_texture == null:
		return
	$TextureRect.texture = image_item.image_texture


func remove():
	Nodes.references.selected_collection.remove_reference(image_item)
	queue_free()
