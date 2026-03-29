extends Node

var apps := {} # key -> Application
var assignments_done: int = 0


func open_app(app_data: AppData, desktop: Control) -> Application:
	var id: String = app_data.app_name
	var scene: PackedScene = app_data.app_scene
	
	if apps.has(id):
		var app = apps[id]
		app.show()
		return app
	
	var app = scene.instantiate() as Application
	desktop.add_child(app, true)
	app.global_position = desktop.get_viewport_rect().size / 2
	app.z_index = 100
	app.move_to_front()
	
	apps[id] = app
	return app

func get_app(app_data: AppData) -> Application:
	if app_data:
		var id: String = app_data.app_name
		return apps.get(id)
	else:
		return null

func minimize_app(app_data: AppData):
	var id: String = app_data.app_name
	if apps.has(id):
		apps[id].hide()
		apps[id].minimized = true

func close_app(app_data: AppData):
	var id: String = app_data.app_name
	if apps.has(id):
		apps[id].closed = true
