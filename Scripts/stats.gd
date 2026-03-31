extends Panel

@onready var assignments_num: Label = $VBoxContainer2/AssignmentsNum
@onready var average_num: Label = $VBoxContainer2/AverageNum
@onready var perfects_num: Label = $VBoxContainer2/PerfectsNum
@onready var upgrades_num: Label = $VBoxContainer2/UpgradesNum

func _process(delta: float) -> void:
	assignments_num.text = str(Global.assignments_done)
	average_num.text = str(int(Global.current_average))
