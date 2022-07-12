extends GridContainer


func _ready():
	Nodes.item_container = self


func populate(collection):
	print("Populating with collection: %s" % collection)
	for child in get_children():
		child.queue_free()
	var ListableImageItem = load("res://listables/ImageItem.tscn")
	for image_item in collection.references:
		var listable_image_item = ListableImageItem.instance()
		listable_image_item.image_item = image_item
		add_child(listable_image_item)
	if collection.references.size() > 0:
		Nodes.references.drag_drop.hide()
	else:
		Nodes.references.drag_drop.show()


func _on_Container_resized():
	rect_size.x = get_parent().get_rect().size.x
	columns = int(floor((rect_size.x / 105.0) * 0.95))
