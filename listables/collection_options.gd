extends OptionButton

signal after_item_selected(collection)

var selected_collection : Collection


func _ready():
	var _err = connect("item_selected", self, "_on_item_selected")


func _on_item_selected(index):
	if index == -1:
		return
	selected_collection = Global.collections[index]
	emit_signal("after_item_selected", selected_collection)


func select_collection(collection):
	for i in range(Global.collections.size()):
		if Global.collections[i] == collection:
			select(i)
			return


func update_data():
	var previous = selected
	var collection_count = Global.collections.size()
	clear()
	for collection in Global.collections:
		add_item(collection.name)
	if collection_count == 0:
		return
	if previous == -1:
		previous = 0
	if previous >= collection_count:
		previous = collection_count - 1
	if get_item_count() > previous:
		select(previous)
		selected_collection = Global.collections[previous]
		return selected_collection
