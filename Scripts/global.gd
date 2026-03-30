extends Node

var apps := {}        # id -> Application
var app_order: Array[Application] = []
var used_assignments: Array[AssignmentData] = []
var graded_assignments: Array[AssignmentData] = []
var assignments_done: int = 0
var current_average: float = 0

func open_app(app_data: AppData, desktop: Control) -> Application:
	var id: String = app_data.app_name
	var scene: PackedScene = app_data.app_scene
	
	if apps.has(id):
		var app = apps[id]
		app.show()
		app.reset_app()
		bring_to_front(app)
		return app
	
	var app = scene.instantiate() as Application
	desktop.add_child(app, true)

	app_order.append(app)
	_update_z()

	app.global_position = desktop.get_viewport_rect().size / 2
	apps[id] = app
	return app

# Open an app instance tied to a specific assignment
func open_app_for_assignment(app_data: AppData, desktop: Control, assignment: AssignmentData) -> Application:
	var id: String = app_data.app_name + "::" + assignment.assignment_title
	
	if apps.has(id):
		var app = apps[id]
		app.show()
		bring_to_front(app)
		return app
	
	var app = app_data.app_scene.instantiate() as Application
	desktop.add_child(app, true)
	app_order.append(app)
	_update_z()
	app.global_position = desktop.get_viewport_rect().size / 2
	apps[id] = app
	return app

func _update_z():
	for i in range(app_order.size()):
		app_order[i].z_index = i

func bring_to_front(app: Application):
	app_order.erase(app)
	app_order.append(app)
	_update_z()

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

func assignment_done(assignment: AssignmentData):
	graded_assignments.append(assignment)
	assignments_done += 1
	var total: float = 0
	for a in graded_assignments:
		total += a.grade
	current_average = total / assignments_done
	
