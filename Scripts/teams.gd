extends Panel

@onready var button_container: VBoxContainer = $AssignmentList/ScrollContainer/ButtonContainer
@onready var assignment_list: Control = $AssignmentList
@onready var assignment_details: Control = $AssignmentDetails
@onready var title: Label = $AssignmentDetails/VBoxContainer/Title
@onready var details: Label = $AssignmentDetails/VBoxContainer/Details

var current_assignment: AssignmentData = null
var current_teacher: TeacherData = null
var current_button: AssignmentButton = null
var current_work = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assignment_list.show()
	assignment_details.hide()
	for button in button_container.get_children():
		button.pressed.connect(_on_button_pressed.bind(button))

func _on_button_pressed(button: AssignmentButton):
	assignment_list.hide()
	assignment_details.show()
	current_button = button
	current_assignment = current_button.assignment
	current_teacher = current_button.teacher
	title.text = current_assignment.assignment_title
	details.text = current_assignment.assignment_details

func _on_back_button_pressed() -> void:
	assignment_details.hide()
	assignment_list.show()
	current_assignment = null

func _on_new_button_pressed() -> void:
	Global.open_app(current_teacher.specialty, get_parent().desktop)

func _on_turn_in_button_pressed() -> void:
	assignment_details.hide()
	assignment_list.show()
	current_button.queue_free()
	current_button = null
	Global.assignments_done += 1
