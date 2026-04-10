extends Resource
class_name AssignmentData

@export var assignment_title: String
@export_multiline var assignment_details: String
@export var min_words: int
@export var min_coverage: float

# VSCode fields
@export_multiline var starter_code: String
@export_multiline var solution_code: String
@export var check_lines: PackedStringArray

var grade: float
var saved_text: String = ""
var saved_image: Image = null
var has_work: bool = false
