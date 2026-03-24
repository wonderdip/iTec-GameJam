extends TextureButton
class_name AppButton

@export var app_name: String = ""
@export var app_scene: PackedScene

var app_node: Control
var scene_added: bool = false

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
	if app_scene and not scene_added:
		var app = app_scene.instantiate()
		add_child(app, true)
		app_node = app
		app_node.global_position = (get_viewport_rect().size / 2 + app_node.size / 2)
		scene_added = true
		z_index = 100
		
	elif scene_added:
		app_node.show()
