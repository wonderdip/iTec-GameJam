extends Panel

@onready var button_container: VBoxContainer = $AssignmentList/UpcomingScroller/ButtonContainer
@onready var assignment_list: Control = $AssignmentList
@onready var assignment_details: Control = $AssignmentDetails
@onready var title: Label = $AssignmentDetails/VBoxContainer/Title
@onready var details: Label = $AssignmentDetails/VBoxContainer/Details
@onready var handed_in_buttons: VBoxContainer = $AssignmentList/HandedInScroller/HandedInButtons
@onready var upcoming_scroller: ScrollContainer = $AssignmentList/UpcomingScroller
@onready var handed_in_scroller: ScrollContainer = $AssignmentList/HandedInScroller
@onready var turn_in_button: Button = $AssignmentDetails/TurnInButton
@onready var new_button: Button = $AssignmentDetails/VBoxContainer/NewButton
@onready var grade_label: Label = $AssignmentDetails/Grade

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
	if current_assignment.min_words > 0:
		details.text = (current_assignment.assignment_details 
						+"\nMinimum Words: " 
						+ str(current_assignment.min_words))
	grade_label.text = (str(int(current_assignment.grade)) + "/100")

func _on_back_button_pressed() -> void:
	assignment_details.hide()
	assignment_list.show()
	current_assignment = null

func _on_new_button_pressed() -> void:
	# Save any existing work first
	var existing_id = current_teacher.specialty.app_name + "::" + current_assignment.assignment_title
	if Global.apps.has(existing_id):
		Global.apps[existing_id].save_work_to_assignment()
	
	var app = Global.open_app_for_assignment(
		current_teacher.specialty, 
		get_parent().desktop, 
		current_assignment
	)
	app.current_assignment = current_assignment
	
	if not current_assignment.has_work:
		app.reset_app()  # fresh canvas/doc for new work
	
	current_assignment.has_work = true
	new_button.disabled = true
	
func _on_turn_in_button_pressed() -> void:
	var app_id = current_teacher.specialty.app_name + "::" + current_assignment.assignment_title
	var grade := 0.0
	
	if Global.apps.has(app_id):
		var app = Global.apps[app_id]
		if current_assignment.min_words > 0:
			var word_count = app.get_word_count()
			grade = clamp(float(word_count) / current_assignment.min_words * 100.0, 0.0, 100.0)
		else:
			var coverage = app.get_canvas_coverage()
			grade = clamp(coverage / current_assignment.min_coverage * 100.0, 0.0, 100.0)
	
	current_assignment.grade = grade
	
	assignment_details.hide()
	assignment_list.show()
	current_button.reparent(handed_in_buttons)
	current_button.add_grade(int(grade))
	current_button = null
	Global.assignment_done(current_assignment)

func _on_work_button_pressed() -> void:
	var app = Global.open_app_for_assignment(
		current_teacher.specialty,
		get_parent().desktop,
		current_assignment
	)
	app.current_assignment = current_assignment
	app.load_work_from_assignment()

func _on_upcoming_list_pressed() -> void:
	upcoming_scroller.show()
	handed_in_scroller.hide()

func _on_handed_in_list_pressed() -> void:
	handed_in_scroller.show()
	upcoming_scroller.hide()

func _process(_delta: float) -> void:
	if not current_assignment:
		return
	
	var already_graded = current_assignment.grade > 0
	
	turn_in_button.disabled = already_graded or not current_assignment.has_work
	new_button.disabled = already_graded or current_assignment.has_work
		
