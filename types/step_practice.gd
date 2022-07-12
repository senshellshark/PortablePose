class_name StepPractice
extends RoutineStep

export var collection : Resource
export var reps : int
export var image_time : float
export var after_time : float


func _to_string():
	return "[StepBreak:%sreps%ss/%s]" % [reps, image_time, after_time]
