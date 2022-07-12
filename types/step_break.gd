class_name StepBreak
extends RoutineStep

export var break_time : float


func _to_string():
	return "[StepBreak:%ss]" % break_time
