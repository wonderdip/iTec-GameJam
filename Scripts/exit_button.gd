extends TextureButton

@export var window: Control

func _ready() -> void:
	pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_hovered():
		texture_hover = texture_normal
		modulate = Color(0.5, 0.5, 0.5)
			
	else:
		modulate = Color.WHITE

func _on_button_pressed():
	window.hide()
