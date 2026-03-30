extends Control
class_name Application

var closed: bool = false
var minimized: bool = false

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
