extends MarginContainer

var selected = "References"

export var references_button : NodePath
export var routine_button : NodePath


func _ready():
	$References.show()
	$Routine.hide()


func switch_view(n):
	if n == selected:
		return
	get_node(selected).hide()
	get_node(n).show()
	get_node(self["%s_button" % selected.to_lower()]).pressed = false
	get_node(self["%s_button" % n.to_lower()]).pressed = true
	selected = n


func _on_References_toggled(button_pressed):
	if button_pressed:
		switch_view("References")


func _on_Routine_toggled(button_pressed):
	if button_pressed:
		switch_view("Routine")
