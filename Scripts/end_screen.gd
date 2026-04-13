extends Control

@onready var date_label: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer3/DateLabel
@onready var body_text: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer3/BodyText

@export var start_scene: PackedScene

func _ready() -> void:
	hide()
	Global.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	date_label.text = "Week %d Day %d" % [Global.current_week, Global.current_day]
	body_text.text = (
		"Due to your TERRIBLE grades this year (%d%%) in the iTek program. " % roundi(Global.current_average) +
		"You have been put on probation indefinitely.\n\nSincerely,\nMr. Broad, iTek Coordinator"
	)
	show()

func _on_home_button_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_packed(start_scene)
