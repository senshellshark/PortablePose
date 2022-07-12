extends Node

var options = Options.new()

var collections : Array
var routine : Routine

var ready_to_load_options = false

var collection_number = 0

func _ready():
	var _err = connect("tree_exiting", self, "_on_tree_exiting")
	if ResourceLoader.exists('user://options.res'):
		options = ResourceLoader.load('user://options.res')
		if options is Options:
			ready_to_load_options = true


func _on_tree_exiting():
	save_options()


func load_options():
	if ready_to_load_options:
		collections = options.collections
		routine = options.routine
		for collection in collections:
			for item in collection.references:
				item.load_texture()
		Nodes.references.update_data()
		Nodes.routine.update_data()
	else:
		routine = Routine.new()
	Nodes.loading.hide()


func save_options():
	options.collections = collections
	options.routine = routine
	var _err = ResourceSaver.save('user://options.res', options)
