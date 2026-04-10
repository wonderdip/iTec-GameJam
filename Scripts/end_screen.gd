extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	hide()
	Global.game_over.connect(_on_game_over)
	
func _on_game_over():
	show()
