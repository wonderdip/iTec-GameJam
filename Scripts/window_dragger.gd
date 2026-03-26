extends Control
class_name AppDragger

@export var app: Application
var desktop: Control  # area to clamp to

var dragging := false

func _ready() -> void:
	desktop = app.get_parent_control()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		app.global_position += event.relative

		var rect = desktop.get_global_rect()

		# Offset of the dragger within the app, so the titlebar stays visible
		var dragger_offset_y = position.y  # dragger's local Y inside app

		# Clamp so dragger top never goes above desktop top
		app.global_position.y = max(app.global_position.y, rect.position.y - dragger_offset_y)
		app.global_position.y = min(app.global_position.y, rect.position.y + rect.size.y - dragger_offset_y - size.y)
		
		app.global_position.x = clamp(
			app.global_position.x,
			rect.position.x,
			rect.position.x + rect.size.x - app.size.x
		)
