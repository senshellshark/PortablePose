extends Panel

onready var bar = $MarginContainer/VBoxContainer/ProgressBar
onready var label = $MarginContainer/VBoxContainer/Label

func _ready():
	pass # Replace with function body.

func _on_Close_timeout():
	visible = false
