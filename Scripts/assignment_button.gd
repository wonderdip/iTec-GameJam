extends Button
class_name AssignmentButton

@export_multiline var title: String = ""
@onready var title_label: Label = $VBoxContainer/AssignmentTitle
@onready var teacher_label: Label = $VBoxContainer/Teacher

const TEACHERS := [
	"Mr. Hahnel",
	"Mr. Larouche",
	"Mr. Nadeau",
	"Mr. Deslippes",
	"Mr. Broad",
	"Mr. Swieca",
	"Mr. Swift"
]

func _ready() -> void:
	title_label.text = title
	teacher_label.text = TEACHERS.pick_random()
	
