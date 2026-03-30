extends ColorRect
class_name Canvas

var current_color: Color = Color.BLACK
var brush_size: int = 3
var eraser: bool = false
var bucket: bool = false

var image: Image
var texture: ImageTexture

var drawing := false

@onready var pencil_button: TextureButton = $"../HBoxContainer/Pencil"
@onready var eraser_button: TextureButton = $"../HBoxContainer/Eraser"
@onready var bucket_button: TextureButton = $"../HBoxContainer/Bucket"
@onready var current_color_rect: ColorRect = $"../CurrentColor"

func _ready():
	reset_canvas()

func reset_canvas():
	@warning_ignore("narrowing_conversion")
	image = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	texture = ImageTexture.create_from_image(image)
	
func _draw():
	draw_texture(texture, Vector2.ZERO)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if bucket:
			bucket_fill(event.position)
		else:
			drawing = true

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
		drawing = false

	if event is InputEventMouseMotion and drawing and !bucket:
		draw_at(event.position)

func draw_at(pos: Vector2):
	var draw_color = Color.WHITE if eraser else current_color

	for x in range(-brush_size, brush_size):
		for y in range(-brush_size, brush_size):
			var px := int(pos.x + x)
			var py := int(pos.y + y)

			if px >= 0 and py >= 0 and px < image.get_width() and py < image.get_height():
				image.set_pixel(px, py, draw_color)

	texture.update(image)
	queue_redraw()

func bucket_fill(pos: Vector2):
	var x := int(pos.x)
	var y := int(pos.y)

	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return

	var target_color := image.get_pixel(x, y)
	var fill_color := Color.WHITE if eraser else current_color

	if target_color == fill_color:
		return

	var stack := [Vector2i(x, y)]

	while stack.size() > 0:
		var p: Vector2i = stack.pop_back()

		if p.x < 0 or p.y < 0 or p.x >= image.get_width() or p.y >= image.get_height():
			continue

		if image.get_pixel(p.x, p.y) != target_color:
			continue

		image.set_pixel(p.x, p.y, fill_color)

		stack.append(Vector2i(p.x + 1, p.y))
		stack.append(Vector2i(p.x - 1, p.y))
		stack.append(Vector2i(p.x, p.y + 1))
		stack.append(Vector2i(p.x, p.y - 1))

	texture.update(image)
	queue_redraw()

func _process(_delta: float) -> void:
	if pencil_button.button_pressed:
		pencil_button.modulate = Color(0.5, 0.5, 0.5)
	else:
		pencil_button.modulate = Color.WHITE
		
	if eraser_button.button_pressed:
		eraser_button.modulate = Color(0.5, 0.5, 0.5)
	else:
		eraser_button.modulate = Color.WHITE
		
	if bucket_button.button_pressed:
		bucket_button.modulate = Color(0.5, 0.5, 0.5)
	else:
		bucket_button.modulate = Color.WHITE
	
	current_color_rect.color = current_color
	
func get_painted_ratio() -> float:
	var painted := 0
	for x in image.get_width():
		for y in image.get_height():
			if image.get_pixel(x, y) != Color.WHITE:
				painted += 1
	return float(painted) / (image.get_width() * image.get_height())
	
func _on_brush_size_value_changed(value: float) -> void:
	brush_size = int(value)

func _on_pencil_pressed() -> void:
	eraser = false
	bucket = false

func _on_eraser_pressed() -> void:
	eraser = true
	bucket = false
	
func _on_bucket_pressed() -> void:
	bucket = true
	eraser = false

func _on_reset_button_pressed() -> void:
	print("6767")
	reset_canvas()
	bucket = false
	eraser = false
	current_color = Color.BLACK
