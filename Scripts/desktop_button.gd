extends TextureButton
class_name DesktopButton

@export_enum("Stats", "Files", "Teams", "Photoshop") var App: String
@export var app_scene: PackedScene
@onready var desktop: Control = $"../../.."

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
	app_node = Global.open_app(App, app_scene, desktop)
