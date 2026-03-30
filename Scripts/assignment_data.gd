extends Resource
class_name AssignmentData

@export var assignment_title: String
@export_multiline var assignment_details: String
@export var min_words: int
@export var min_coverage: float

var grade: float

# Saved work state
var saved_text: String = ""       # for Word
var saved_image: Image = null     # for Photoshop
var has_work: bool = false
