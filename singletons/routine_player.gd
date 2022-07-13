extends ColorRect

onready var image_timer : Timer = $ImageTimer
onready var after_timer : Timer = $AfterTimer
onready var break_timer : Timer = $BreakTimer

var remaining_steps = []
var remaining_reps = 0
var images_done = []
var max_reps = 1

var current_collection : Collection

var current_timer = NONE setget set_current_timer

enum { NONE, IMAGE, AFTER, BREAK }

func _ready():
	Nodes.routine_player = self


func _process(_delta):
	$PlayerControls/HBoxContainer/VBoxContainer/TimeRemaining.text = str(int(get_current_timer().time_left))
	$PlayerControls/HBoxContainer/VBoxContainer/RepCount.text = "%s / %s" % [remaining_reps, max_reps]


func set_current_timer(_current_timer):
	current_timer = _current_timer
	var n = ["NONE", "IMAGE", "AFTER", "BREAK"]
	print("Current Timer: %s" % n[current_timer])


func get_current_timer():
	match current_timer:
		IMAGE:
			return image_timer
		AFTER:
			return after_timer
	return break_timer


func play():
	remaining_steps = []
	images_done = []
	current_timer = NONE
	current_collection = Nodes.references.selected_collection
	remaining_steps.append_array(Global.routine.routine_steps)
	print(remaining_steps)
	$CurrentImage.hide()
	show()
	next_step()


func next_step():
	if remaining_steps.size() == 0:
		stop()
		return
	var next_step = remaining_steps.pop_front()
	if next_step is StepPause:
		$PlayerControls/HBoxContainer/Control/PlayPause.pressed = true
		break_timer.wait_time = 3
		current_timer = BREAK
		break_timer.start()
	if next_step is StepBreak:
		break_timer.wait_time = next_step.break_time
		current_timer = BREAK
		break_timer.start()
	if next_step is StepCollection:
		current_collection = next_step.collection
		next_step()
	if next_step is StepPractice:
		image_timer.wait_time = next_step.image_time if not next_step.image_time == 0 else 5
		after_timer.wait_time = next_step.after_time if not next_step.after_time == 0 else 1
		remaining_reps = next_step.reps if not next_step.reps == 0 else 1
		max_reps = next_step.reps if not next_step.reps == 0 else 1
		show_image()
	print("REMAINING STEPS:")
	print(remaining_steps)


func stop():
	$PlayerControls/HBoxContainer/Control/PlayPause.pressed = false
	image_timer.stop()
	after_timer.stop()
	break_timer.stop()
	hide()


func show_image():
	if current_collection.references.size() == 0:
		stop()
		return
	if current_collection.references.size() == images_done.size():
		var last_image_index = images_done.pop_back()
		images_done = []
	var i = randi() % current_collection.references.size()
	if images_done.size() > 0:
		while images_done.has(i):
			i = randi() % current_collection.references.size()
	images_done.append(i)
	$CurrentImage.texture = current_collection.references[i].image_texture
	$CurrentImage.show()
	current_timer = IMAGE
	image_timer.start()


func _on_ImageTimer_timeout():
	$CurrentImage.hide()
	current_timer = AFTER
	after_timer.start()


func _on_AfterTimer_timeout():
	remaining_reps -= 1
	if remaining_reps == 0:
		next_step()
		return
	show_image()


func _on_BreakTimer_timeout():
	next_step()


func _on_PlayPause_toggled(pause):
	image_timer.paused = pause
	after_timer.paused = pause
	break_timer.paused = pause


func _on_Stop_pressed():
	stop()
