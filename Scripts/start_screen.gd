extends Control

@onready var username_screen: Control = $UsernameScreen
@onready var intro: Control = $Intro
@onready var label: Label = $Intro/VBoxContainer/Label
@onready var next_button: Button = $Intro/VBoxContainer/HBoxContainer/NextButton
@onready var leaderboard_container: VBoxContainer = $UsernameScreen/LeaderboardContainer
@onready var user_container: VBoxContainer = $UsernameScreen/UserContainer

@export var intro_texts: Array[String] = [
	"Welcome to the iTek Simulator!",
	"This is a Desktop/UI sim game where you will play through the life of a iTek Student struggling to hand work",
	"Every DAY (25sec) you'll get new assignments that you have to hand in to get graded.",
	"Many of these assignments are inspired by real ones so this is good practice",
	"Every WEEK the minimum average you need, will go up by 10%.",
	"Use teams and the other apps to create work and hand it in",
	"Fail to keep up with the average and you'll get a scary email from Mr.Broad.",
	"Good luck and Do NOT fail!"
]
@export var letter_delay: float = 0.04
@export var desktop_scene: PackedScene

var text_index: int = 0
var is_typing: bool = false

func _ready() -> void:
	username_screen.hide()
	leaderboard_container.hide()
	intro.show()
	display_text()

func show_username_screen() -> void:
	username_screen.show()
	intro.hide()
	_populate_leaderboard()

func _populate_leaderboard() -> void:
	for child in leaderboard_container.get_children():
		child.queue_free()
	
	_add_leaderboard_row("Player", "Average", "Reached")
	
	if Global.leaderboard.is_empty():
		var empty_label = Label.new()
		empty_label.text = "No runs yet!"
		leaderboard_container.add_child(empty_label)
		return
	
	var sorted = Global.leaderboard.duplicate()
	sorted.sort_custom(func(a, b):
		if a.week != b.week:
			return a.week > b.week
		return a.day > b.day
	)
	
	for entry in sorted:
		_add_leaderboard_row(
			entry.username,
			str(roundi(entry.average)) + "%",
			"Week %d Day %d" % [entry.week, entry.day]
		)

func _add_leaderboard_row(player: String, average: String, reached: String) -> void:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)
	
	var cols = [player, average, reached]
	var sizes = [90, 40, 90]
	
	for i in cols.size():
		var player_label = Label.new()
		player_label.text = cols[i]
		player_label.custom_minimum_size.x = sizes[i]
		player_label.clip_text = true
		row.add_child(player_label)
	
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
		if not is_typing:
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

func _on_skip_button_pressed() -> void:
	show_username_screen()

func _on_leader_board_button_pressed() -> void:
	if leaderboard_container.visible:
		leaderboard_container.hide()
		user_container.show()
	else:
		leaderboard_container.show()
		user_container.hide()
