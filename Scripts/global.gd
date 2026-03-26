extends Node

var apps := {} # key -> Application

func open_app(id: String, scene: PackedScene, desktop: Control) -> Application:
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

func get_app(id: String) -> Application:
	return apps.get(id)

func minimize_app(id: String):
	if apps.has(id):
		apps[id].hide()
		apps[id].minimized = true

func close_app(id: String):
	if apps.has(id):
		apps[id].closed = true
