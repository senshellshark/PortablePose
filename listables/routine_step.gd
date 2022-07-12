extends Panel

var routine_step : RoutineStep setget set_routine_step


func _ready():
	# update()
	pass


func set_routine_step(_routine_step):
	routine_step = _routine_step
	update_data()


func update_data():
	if routine_step is StepBreak:
		$MarginContainer/HBoxContainer/Control/Break/BreakTime.text = String(routine_step.break_time)
		$MarginContainer/HBoxContainer/Control/Break.show()
	if routine_step is StepPractice:
		$MarginContainer/HBoxContainer/Control/Practice/PracticeReps.text = String(routine_step.reps)
		$MarginContainer/HBoxContainer/Control/Practice/PracticeImageTime.text = String(routine_step.image_time)
		$MarginContainer/HBoxContainer/Control/Practice/PracticeAfterTime.text = String(routine_step.after_time)
		$MarginContainer/HBoxContainer/Control/Practice.show()
	if routine_step is StepPause:
		$MarginContainer/HBoxContainer/Control/Pause.show()
	if routine_step is StepCollection:
		$MarginContainer/HBoxContainer/Control/Collection/CollectionName.update_data()
		$MarginContainer/HBoxContainer/Control/Collection.show()


func _on_CollectionName_after_item_selected(collection):
	routine_step.collection = collection


func _on_PracticeReps_text_entered(new_text):
	routine_step.reps = int(new_text)
	update_data()


func _on_PracticeImageTime_text_entered(new_text):
	routine_step.image_time = float(new_text)
	update_data()


func _on_PracticeAfterTime_text_entered(new_text):
	routine_step.after_time = float(new_text)
	update_data()


func _on_BreakTime_text_entered(new_text):
	routine_step.break_time = float(new_text)
	update_data()


func _on_Remove_pressed():
	Global.routine.routine_steps.erase(routine_step)
	queue_free()


func _on_PracticeReps_text_changed(new_text):
	routine_step.reps = int(new_text)


func _on_PracticeImageTime_text_changed(new_text):
	routine_step.image_time = float(new_text)


func _on_PracticeAfterTime_text_changed(new_text):
	routine_step.after_time = float(new_text)


func _on_BreakTime_text_changed(new_text):
	routine_step.break_time = float(new_text)
