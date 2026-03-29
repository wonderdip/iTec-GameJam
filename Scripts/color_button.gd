extends TextureButton
class_name ColorButton

@export_color_no_alpha var color: Color
@onready var canvas: ColorRect = $"../../../../Canvas"

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	var img := Image.create_empty(5, 5, false, Image.FORMAT_RGBA8)
	img.fill(color)

	var tex := ImageTexture.create_from_image(img)
	texture_normal = tex

func _process(_delta: float) -> void:
	if is_hovered():
		modulate = Color(0.5, 0.5, 0.5)
			
	else:
		modulate = Color.WHITE

func _on_button_pressed():
	canvas.current_color = color
