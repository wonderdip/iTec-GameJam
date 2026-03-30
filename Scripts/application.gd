extends Control
class_name Application

var closed: bool = false
var minimized: bool = false
var current_assignment: AssignmentData = null  # which assignment this instance belongs to

@export var teachers: Array[TeacherData]
@export var canvas: Canvas
@export var text_edit: TextEdit

var desktop: Control

func _ready() -> void:
	desktop = get_parent_control()

func reset_app():
	if canvas:
		canvas.reset_canvas()
	if text_edit:
		text_edit.clear()

func save_work_to_assignment():
	if not current_assignment:
		return
	if text_edit:
		current_assignment.saved_text = text_edit.text
		current_assignment.has_work = text_edit.text.length() > 0
	if canvas:
		current_assignment.saved_image = canvas.image.duplicate()
		current_assignment.has_work = true

func load_work_from_assignment():
	if not current_assignment:
		return
	if text_edit and current_assignment.saved_text != "":
		text_edit.text = current_assignment.saved_text
	if canvas and current_assignment.saved_image:
		canvas.image = current_assignment.saved_image.duplicate()
		canvas.texture.update(canvas.image)
		canvas.queue_redraw()

func get_word_count() -> int:
	if not text_edit:
		return 0
	var text = text_edit.text.strip_edges()
	if text == "":
		return 0
	return text.split(" ", false).size()

func get_canvas_coverage() -> float:
	if not canvas:
		return 0.0
	return canvas.get_painted_ratio()
	
