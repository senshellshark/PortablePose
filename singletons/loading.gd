class_name Loading
extends Panel

onready var bar = $MarginContainer/VBoxContainer/ProgressBar
onready var label = $MarginContainer/VBoxContainer/Label
onready var close = $Close


func _ready():
	Nodes.loading = self


func _on_Close_timeout():
	visible = false
