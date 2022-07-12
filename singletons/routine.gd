extends Control


onready var ListableRoutineStep = load("res://listables/RoutineStep.tscn")

onready var routine_list = $HSplitContainer/ScrollContainer/RoutineList

func _ready():
	Nodes.routine = self


func update_data():
	if routine_list.get_child_count() == 0:
		for routine_step in Global.routine.routine_steps:
			var listable_routine_step = ListableRoutineStep.instance()
			listable_routine_step.routine_step = routine_step
			routine_list.add_child(listable_routine_step)
	for routine_step in routine_list.get_children():
		routine_step.update_data()


func _on_Practice_pressed():
	var listable_routine_step = ListableRoutineStep.instance()
	var step_practice = StepPractice.new()
	step_practice.reps = 20
	step_practice.image_time = 15
	step_practice.after_time = 1
	listable_routine_step.routine_step = step_practice
	Global.routine.routine_steps.append(step_practice)
	routine_list.add_child(listable_routine_step)


func _on_Break_pressed():
	var listable_routine_step = ListableRoutineStep.instance()
	var step_break = StepBreak.new()
	step_break.break_time = 15
	listable_routine_step.routine_step = step_break
	Global.routine.routine_steps.append(step_break)
	routine_list.add_child(listable_routine_step)


func _on_Pause_pressed():
	var listable_routine_step = ListableRoutineStep.instance()
	var step_pause = StepPause.new()
	listable_routine_step.routine_step = step_pause
	Global.routine.routine_steps.append(step_pause)
	routine_list.add_child(listable_routine_step)


func _on_Collection_pressed():
	var listable_routine_step = ListableRoutineStep.instance()
	var step_collection = StepCollection.new()
	step_collection.collection = Nodes.references.selected_collection
	listable_routine_step.routine_step = step_collection
	Global.routine.routine_steps.append(step_collection)
	routine_list.add_child(listable_routine_step)


func _on_Start_pressed():
	Nodes.routine_player.play()
