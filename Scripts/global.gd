extends Node
signal day_changed(day: int)
signal week_changed(week: int)
signal game_over

var current_user: String
var apps := {}
var app_order: Array[Application] = []
var used_assignments: Array[AssignmentData] = []
var graded_assignments: Array[AssignmentData] = []
var assignments_done: int = 0
var failed_assignments: int = 0
var current_average: float = 0
var current_week: int = 1
var current_day: int = 1
var days_per_week: int = 5
var day_duration: float = 25.0
var day_timer: float = 0.0
var week_failed: bool = false
var game_running: bool = false

# Leaderboard entry structure
class LeaderboardEntry:
	var username: String
	var average: float
	var week: int
	var day: int
	
	func _init(u: String, avg: float, w: int, d: int) -> void:
		username = u
		average = avg
		week = w
		day = d

var leaderboard: Array[LeaderboardEntry] = []

func start_game(username: String) -> void:
	current_user = username
	game_running = true
	_reset_run_vars()

func reset() -> void:
	if week_failed:
		leaderboard.append(LeaderboardEntry.new(
			current_user,
			current_average,
			current_week,
			current_day
		))
	
	_reset_run_vars()
	game_running = false

func _reset_run_vars() -> void:
	for app in app_order:
		if is_instance_valid(app):
			app.queue_free()
	apps.clear()
	app_order.clear()
	used_assignments.clear()
	graded_assignments.clear()
	assignments_done = 0
	failed_assignments = 0
	current_average = 0.0
	current_week = 1
	current_day = 1
	day_timer = 0.0
	week_failed = false

func get_required_average() -> float:
	return 50.0 + (current_week * 10.0)

func _process(delta: float) -> void:
	if not game_running or week_failed:
		return
	day_timer += delta
	if day_timer >= day_duration:
		day_timer = 0.0
		_advance_day()

func _advance_day() -> void:
	if current_average < get_required_average():
		week_failed = true
		game_over.emit()
	elif current_day >= days_per_week:
		_end_week()
	else:
		current_day += 1
		day_changed.emit(current_day)

func _end_week() -> void:
	current_week += 1
	current_day = 1
	current_average = 0
	week_changed.emit(current_week)
	day_changed.emit(current_day)

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

func _update_z() -> void:
	for i in range(app_order.size()):
		app_order[i].z_index = i

func bring_to_front(app: Application) -> void:
	app_order.erase(app)
	app_order.append(app)
	_update_z()

func get_app(app_data: AppData) -> Application:
	if app_data:
		return apps.get(app_data.app_name)
	return null

func minimize_app(app_data: AppData) -> void:
	var id: String = app_data.app_name
	if apps.has(id):
		apps[id].hide()
		apps[id].minimized = true

func close_app(app_data: AppData) -> void:
	var id: String = app_data.app_name
	if apps.has(id):
		apps[id].closed = true

func assignment_done(assignment: AssignmentData) -> void:
	graded_assignments.append(assignment)
	assignments_done += 1
	var total: float = 0
	for a in graded_assignments:
		total += a.grade
	current_average = total / assignments_done
	if assignment.grade < 60:
		failed_assignments += 1
