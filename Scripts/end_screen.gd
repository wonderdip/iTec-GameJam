extends Control

@onready var date_label: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer3/DateLabel
@onready var body_text: Label = $Panel/VBoxContainer/HBoxContainer/VBoxContainer3/BodyText
@onready var home_button: Button = $Panel/HomeButton

var is_typing: bool
var letter_delay: float = 0.04

func _ready() -> void:
	hide()
	home_button.hide()
	Global.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	date_label.text = "Week %d Day %d" % [Global.current_week, Global.current_day]
	body_text.text = (
		"Due to your TERRIBLE grades this year (%d%%) in the iTek program. " % roundi(Global.current_average) +
		"You have been put on probation indefinitely.\n\nSincerely,\nMr. Broad, iTek Coordinator"
	)
	var tween = create_tween()
	scale = Vector2(0.1, 0.1)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.25)
	type_text()
	show()


func type_text() -> void:
	is_typing = true
	body_text.visible_characters = 0
	for i in body_text.text.length():
		if not is_typing:  # was skipped
			break
		body_text.visible_characters = i + 1
		await get_tree().create_timer(letter_delay).timeout
	is_typing = false
	home_button.show()
	
func _on_home_button_pressed() -> void:
	Global.reset()
	get_tree().change_scene_to_file("res://Scenes/start_screen.tscn")
