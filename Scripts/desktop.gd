extends Control

@onready var week_label: Label = $VBoxContainer/WeekLabel
@onready var day_progress: ProgressBar = $VBoxContainer/DayProgress

func _ready() -> void:
	Global.day_changed.connect(_on_day_changed)
	Global.week_changed.connect(_on_week_changed)
	Global.game_over.connect(_on_game_over)
	_update_label()

func _update_label() -> void:
	week_label.text = ("Week " + str(Global.current_week) 
					  + " Day " + str(Global.current_day) +"/" + str(Global.days_per_week)
					  + " | Need: " + str(int(Global.get_required_average()))
					  + "% | Avg: " + str(roundi(Global.current_average)) + "%")

func _on_day_changed(_day: int) -> void:
	_update_label()

func _on_week_changed(_week: int) -> void:
	_update_label()

func _on_game_over() -> void:
	pass

func _process(delta: float) -> void:
	_update_label()
	day_progress.value = (Global.day_timer / Global.day_duration) * 100.0
