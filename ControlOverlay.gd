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

func _on_Fade_timeout():
	fade = true

func _on_ControlOverlay_gui_input(event):
	fade = false
	$Fade.start()
