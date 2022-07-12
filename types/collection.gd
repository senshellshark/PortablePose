class_name Collection
extends Resource

export var name : String
export var references : Array
export var file_path : String

var changed : bool = false

func remove_reference(image_item):
	references.erase(image_item)

func _to_string():
	return "[Collection:%s(%s)]" % [name, references.size()]
