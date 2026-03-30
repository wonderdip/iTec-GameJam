extends Button
class_name AssignmentButton

@onready var title_label: Label = $VBoxContainer/AssignmentTitle
@onready var teacher_label: Label = $VBoxContainer/Teacher
@onready var teams: Application = $"../../../../.."

var assignment: AssignmentData
var teacher: TeacherData

func _ready() -> void:
	teacher = teams.teachers.pick_random()
	teacher_label.text = (teacher.name + " " + teacher.specialty.app_name)
	assignment = teacher.assignments.pick_random()
	title_label.text = assignment.assignment_title
