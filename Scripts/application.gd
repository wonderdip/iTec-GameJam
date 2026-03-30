extends Control
class_name Application

var closed: bool = false
var minimized: bool = false

@export var teachers: Array[TeacherData]

var desktop: Control

func _ready() -> void:
	desktop = get_parent_control()
