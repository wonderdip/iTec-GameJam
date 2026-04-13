extends Control

@onready var username_screen: Control = $UsernameScreen
@onready var intro: Control = $Intro
@onready var label: Label = $Intro/VBoxContainer/Label
@onready var next_button: Button = $Intro/VBoxContainer/NextButton
@onready var leaderboard_container: VBoxContainer = $UsernameScreen/LeaderboardContainer

@export var intro_texts: Array[String] = [
	"Welcome to the iTek Simulator!",
	"Every DAY you'll get new assignments that you have to hand in to get graded.",
	"Every WEEK the minimum average you need, will go up by 10%.",
	"Fail to keep up with the average and you'll be put on probation.",
	"Good luck and Do NOT fail!"
]
@export var letter_delay: float = 0.04
@export var desktop_scene: PackedScene

var text_index: int = 0
var is_typing: bool = false

func _ready() -> void:
	username_screen.hide()
	intro.show()
	display_text()

func show_username_screen() -> void:
	username_screen.show()
	intro.hide()
	_populate_leaderboard()

func _populate_leaderboard() -> void:
	# Clear old entries
	for child in leaderboard_container.get_children():
		child.queue_free()
	
	if Global.leaderboard.is_empty():
		var empty_label = Label.new()
		empty_label.text = "No runs yet!"
		leaderboard_container.add_child(empty_label)
		return
	
	# Header
	var header = Label.new()
	header.text = "%-20s %8s %12s %20s" % ["Player", "Average", "Reached", "Time"]
	leaderboard_container.add_child(header)
	
	# Sort by week then day descending (furthest run on top)
	var sorted = Global.leaderboard.duplicate()
	sorted.sort_custom(func(a, b):
		if a.week != b.week:
			return a.week > b.week
		return a.day > b.day
	)
	
	for entry in sorted:
		var row = Label.new()
		row.text = "%-20s %7s%% %7s %20s" % [
			entry.username,
			str(roundi(entry.average)),
			"W%d D%d" % [entry.week, entry.day],
			entry.timestamp
		]
		leaderboard_container.add_child(row)

func display_text() -> void:
	if text_index < intro_texts.size():
		type_text(intro_texts[text_index])

func type_text(full_text: String) -> void:
	is_typing = true
	next_button.disabled = true
	label.text = full_text
	label.visible_characters = 0
	for i in full_text.length():
		if not is_typing:  # was skipped
			break
		label.visible_characters = i + 1
		await get_tree().create_timer(letter_delay).timeout
	is_typing = false
	next_button.disabled = false

func change_text() -> void:
	text_index += 1
	display_text()

func _on_next_button_pressed() -> void:
	if is_typing:
		is_typing = false
		label.visible_characters = -1
		next_button.disabled = false
		return
	if text_index < intro_texts.size() - 1:
		change_text()
	else:
		show_username_screen()

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == "":
		return
	Global.start_game(new_text)
	get_tree().change_scene_to_packed(desktop_scene)
