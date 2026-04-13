extends Panel

@onready var code_edit: CodeEdit = $Control/VBoxContainer/CodeEdit
@onready var run_button: Button = $Control/VBoxContainer/HBoxContainer/RunButton
@onready var output_label: Label = $Control/VBoxContainer/HBoxContainer/Output
@onready var filename: Label = $Control/VBoxContainer/Filename

@export var app: Application
	
func _on_run_button_pressed() -> void:
	var code = code_edit.text.strip_edges()
	if code == "":
		output_label.text = "No code to run."
		return
	
	if not app or not app.current_assignment:
		output_label.text = "> No assignment loaded."
		return
	
	var assignment = app.current_assignment
	var all_correct := true
	
	for required_line in assignment.check_lines:
		var found := false
		for line in code.split("\n"):
			if line.strip_edges() == required_line.strip_edges():
				found = true
				break
		if not found:
			all_correct = false
			break
	
	if all_correct:
		output_label.text = "> Successful!"
	else:
		output_label.text = "> Error!"

func _on_button_pressed() -> void:
	#reset button
	var assignment : AssignmentData = app.current_assignment
	code_edit.text = assignment.starter_code
