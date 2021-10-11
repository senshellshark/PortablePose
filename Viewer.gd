extends ColorRect

func _ready():
	pass # Replace with function body.

func _process(delta):
	$MarginContainer/Counters/RepCount.text = str(int($Shown.time_left))
	$MarginContainer/Counters/Remaining.text = "%s / %s" % [get_parent().reps, get_parent().max_reps]
