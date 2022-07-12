extends Control

var selected_collection : Collection
onready var selected_collection_node = $VBoxContainer/MarginContainer/HBoxContainer/SelectedCollection
onready var drag_drop = $VBoxContainer/Control/DragDrop

var images = []
var images_done = []

var image_loading_queue = []

func _ready():
	Nodes.references = self
	var _err = get_tree().connect("files_dropped", self, "_on_files_dropped")
	selected_collection = Collection.new()
	selected_collection.name = "Collection"
	Global.collections.append(selected_collection)
	selected_collection_node.update_data()


func update_data():
	selected_collection_node.update_data()
	selected_collection = Global.collections[0]
	$VBoxContainer/MarginContainer/HBoxContainer/CollectionName.text = Global.collections[0].name
	if Global.collections.size() > 1:
		$VBoxContainer/MarginContainer/HBoxContainer/Remove.disabled = false
	Nodes.item_container.populate(selected_collection)


func _on_files_dropped(paths, _screen):
	Nodes.loading.visible = true
	Nodes.loading.bar.max_value = paths.size()
	Nodes.loading.bar.value = 0
	$VBoxContainer/Control/DragDrop.visible = false
	image_loading_queue.append_array(paths)
	$Load.start()


func _on_Load_timeout():
	if image_loading_queue.size() > 0:
		var image_source = image_loading_queue.pop_front()
		Nodes.loading.label.text = "Loading %s" % image_source
		create_image_item(image_source)
		Nodes.loading.bar.value += 1
		$Load.start()
	else:
		Nodes.loading.close.start()


func create_image_item(image_source : String):
	var image_item = ImageItem.new()
	image_item.load_texture(image_source)
	# print("appending %s to collection %s" % [image_item, selected_collection])
	selected_collection.references.append(image_item)
	var listable_image_item = load("res://listables/ImageItem.tscn").instance()
	listable_image_item.image_item = image_item
	Nodes.item_container.add_child(listable_image_item)


func _on_CollectionName_text_changed(new_text):
	selected_collection.name = new_text
	selected_collection_node.update_data()
	Nodes.routine.update_data()


func _on_Add_pressed():
	var new_collection = Collection.new()
	Global.collection_number += 1
	new_collection.name = "Collection %s" % Global.collection_number
	selected_collection = new_collection
	Global.collections.append(new_collection)
	selected_collection_node.update_data()
	selected_collection_node.select_collection(new_collection)
	Nodes.routine.update_data()
	Nodes.item_container.populate(new_collection)
	$VBoxContainer/MarginContainer/HBoxContainer/CollectionName.text = new_collection.name
	$VBoxContainer/MarginContainer/HBoxContainer/Remove.disabled = false


func _on_Remove_pressed():
	Global.collections.erase(selected_collection)
	var new_selection = selected_collection_node.update_data()
	selected_collection = new_selection
	Nodes.routine.update_data()
	Nodes.item_container.populate(selected_collection)
	$VBoxContainer/MarginContainer/HBoxContainer/CollectionName.text = selected_collection.name
	if Global.collections.size() == 1:
		$VBoxContainer/MarginContainer/HBoxContainer/Remove.disabled = true


func _on_SelectedCollection_after_item_selected(collection):
	selected_collection = collection
	Nodes.item_container.populate(selected_collection)
	$VBoxContainer/MarginContainer/HBoxContainer/CollectionName.text = collection.name
