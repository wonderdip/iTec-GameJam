extends Button
class_name AssignmentButton

@onready var title_label: Label = $VBoxContainer/AssignmentTitle
@onready var teacher_label: Label = $VBoxContainer/Teacher
@onready var teams: Application = $"../../../../.."

var assignment: AssignmentData
var teacher: TeacherData

func _ready() -> void:
	var available_teachers = teams.teachers.filter(func(t):
		return t.assignments.any(func(a): return a not in Global.used_assignments)
	)
	
	if available_teachers.is_empty():
		queue_free()  # no assignments left, remove the button
		return
	
	teacher = available_teachers.pick_random()
	
	var available_assignments = teacher.assignments.filter(func(a):
		return a not in Global.used_assignments
	)
	
	assignment = available_assignments.pick_random()
	Global.used_assignments.append(assignment)
	
	teacher_label.text = teacher.name + " " + teacher.specialty.app_name
	title_label.text = assignment.assignment_title
