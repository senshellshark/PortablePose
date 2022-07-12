extends MarginContainer

var fade = false
var alpha = 1

func _ready():
	alpha = 1


func _process(delta):
	if fade:
		if alpha > 0.05: alpha -= 0.7 * delta
	else:
		alpha = 1
	modulate = Color(1, 1, 1, alpha)


func _on_PlayerControls_gui_input(_event):
	fade = false
	$Fade.start()


func _on_Timer_timeout():
	fade = true
