extends Timer


func _on_OptionLoader_timeout():
	Global.load_options()
