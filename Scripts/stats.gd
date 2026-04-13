extends Panel

@onready var itek_user: Label = $ItekUser

@onready var assignments_num: Label = $VBoxContainer2/AssignmentsNum
@onready var average_num: Label = $VBoxContainer2/AverageNum
@onready var failed_num: Label = $VBoxContainer2/FailedNum
@onready var upgrades_num: Label = $VBoxContainer2/UpgradesNum

func _process(_delta: float) -> void:
	assignments_num.text = str(Global.assignments_done)
	average_num.text = str(roundi(Global.current_average))
	failed_num.text = str(Global.failed_assignments)
	itek_user.text = Global.current_user
