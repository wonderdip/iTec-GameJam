extends TextureButton
class_name TaskBarButton

@export_enum("Stats", "Files", "Teams", "Photoshop") var App: String
@export var app_scene: PackedScene
@export var taskbar_indicator: Sprite2D
@onready var desktop: Control = $"../.."

var scene_added: bool = false

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	taskbar_indicator.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_hovered():
		texture_hover = texture_normal
		modulate = Color(0.5, 0.5, 0.5)
			
	else:
		modulate = Color.WHITE
		
	var app_node: Application = Global.get_app(App)
	if app_node:
		taskbar_indicator.visible = app_node.visible
		
func _on_button_pressed():
	var app = Global.open_app(App, app_scene, desktop)
	
	if app.closed:
		app.show()
		app.closed = false
		app.minimized = false
		
	elif app.minimized:
		app.show()
		app.minimized = false
		
	else:
		app.hide()
		app.minimized = true
