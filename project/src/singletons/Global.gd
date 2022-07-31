extends Node
# This is global script which stores global variables and helps with some global processes
# like pausing game, finding nodes at tree, switching scenes etc.

# ---------- VARIABLES ----------

var player_variables: Dictionary
var is_game_paused: bool
var screen_width: float 
var screen_height: float

func _ready() -> void:
	player_variables = Save.load_saved_variables()
	
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
#	Global.info(self, "screen_width=%s, screen_height=%s" % [screen_width, screen_height])
	VisualServer.set_default_clear_color(Color(0, 0, 0, 0))
	is_game_paused = false


func set_player_variable(name: String, value):
	Save.call_deferred("store_variable", name, value)
	Global.info(self, "Saving %s to %s done! Returned %s" % [name, value, Global.parse_error(yield(Save, "saving_done"))])
	player_variables = Save.load_saved_variables()

func get_player_variable(name: String, default = false): # -> Variant
	if not player_variables.has(name):
		set_player_variable(name, default)
	return player_variables[name]

# ---------- FUNTIONS ----------

func find_node_by_name(name, root : Node = get_tree().current_scene):
	if root.get_name() == name: 
		return root
	for child in root.get_children():
		if child.get_name() == name:
			return child
		var found = find_node_by_name(name, child)
		if found: 
			return found
	error("Node %s not found" % name)
	return null


func go_to_scene(scene : PackedScene):
	return get_tree().change_scene_to(scene)


func resume_game(pauseMenu : Control):
	pauseMenu.hide()
	get_tree().paused = false
	is_game_paused = false


func pause_game(pauseMenu : Control):
	pauseMenu.show()
	get_tree().paused = true
	is_game_paused = true


func close_game():
	pass


func info(source: Node = null, message = null):
	var node_path = source.get_path() if source != null else "Unknown node"
	var string := String(message)
	var limit := 834
	if string.length() > limit:
		string = string.substr(0, limit) + "..."
	print("    INFO %s >>>>> %s" % [node_path, string])


func error(message: String):
	print("%s at:" % message)
	print_stack()


func parse_error(err) -> String:
	match err:
		OK: return "OK"
		FAILED: return "FAILED"
		ERR_UNAVAILABLE: return "ERR_UNAVAILABLE"
		ERR_UNCONFIGURED: return "ERR_UNCONFIGURED"
		ERR_UNAUTHORIZED: return "ERR_UNAUTHORIZED"
		ERR_PARAMETER_RANGE_ERROR: return "ERR_PARAMETER_RANGE_ERROR"
		ERR_OUT_OF_MEMORY: return "ERR_OUT_OF_MEMORY"
		ERR_FILE_NOT_FOUND: return "ERR_FILE_NOT_FOUND"
		ERR_FILE_BAD_DRIVE: return "ERR_FILE_BAD_DRIVE"
		ERR_FILE_BAD_PATH: return "ERR_FILE_BAD_PATH"
		ERR_FILE_NO_PERMISSION: return "ERR_FILE_NO_PERMISSION"
		ERR_FILE_ALREADY_IN_USE: return "ERR_FILE_ALREADY_IN_USE"
		ERR_FILE_CANT_OPEN: return "ERR_FILE_CANT_OPEN"
		ERR_FILE_CANT_WRITE: return "ERR_FILE_CANT_WRITE"
		ERR_FILE_CANT_READ: return "ERR_FILE_CANT_READ"
		ERR_FILE_UNRECOGNIZED: return "ERR_FILE_UNRECOGNIZED"
		ERR_FILE_CORRUPT: return "ERR_FILE_CORRUPT"
		ERR_FILE_MISSING_DEPENDENCIES: return "ERR_FILE_MISSING_DEPENDENCIES"
		ERR_FILE_EOF: return "ERR_FILE_EOF"
		ERR_CANT_OPEN: return "ERR_CANT_OPEN"
		ERR_CANT_CREATE: return "ERR_CANT_CREATE"
		ERR_QUERY_FAILED: return "ERR_QUERY_FAILED"
		ERR_ALREADY_IN_USE: return "ERR_ALREADY_IN_USE"
		ERR_LOCKED: return "ERR_LOCKED"
		ERR_TIMEOUT: return "ERR_TIMEOUT"
		ERR_CANT_CONNECT: return "ERR_CANT_CONNECT"
		ERR_CANT_RESOLVE: return "ERR_CANT_RESOLVE"
		ERR_CONNECTION_ERROR: return "ERR_CONNECTION_ERROR"
		ERR_CANT_ACQUIRE_RESOURCE: return "ERR_CANT_ACQUIRE_RESOURCE"
		ERR_CANT_FORK: return "ERR_CANT_FORK"
		ERR_INVALID_DATA: return "ERR_INVALID_DATA"
		ERR_INVALID_PARAMETER: return "ERR_INVALID_PARAMETER"
		ERR_ALREADY_EXISTS: return "ERR_ALREADY_EXISTS"
		ERR_DOES_NOT_EXIST: return "ERR_DOES_NOT_EXIST"
		ERR_DATABASE_CANT_READ: return "ERR_DATABASE_CANT_READ"
		ERR_DATABASE_CANT_WRITE: return "ERR_DATABASE_CANT_WRITE"
		ERR_COMPILATION_FAILED: return "ERR_COMPILATION_FAILED"
		ERR_METHOD_NOT_FOUND: return "ERR_METHOD_NOT_FOUND"
		ERR_LINK_FAILED: return "ERR_LINK_FAILED"
		ERR_SCRIPT_FAILED: return "ERR_SCRIPT_FAILED"
		ERR_CYCLIC_LINK: return "ERR_CYCLIC_LINK"
		ERR_INVALID_DECLARATION: return "ERR_INVALID_DECLARATION"
		ERR_DUPLICATE_SYMBOL: return "ERR_DUPLICATE_SYMBOL"
		ERR_PARSE_ERROR: return "ERR_PARSE_ERROR"
		ERR_BUSY: return "ERR_BUSY"
		ERR_SKIP: return "ERR_SKIP"
		ERR_HELP: return "ERR_HELP"
		ERR_BUG: return "ERR_BUG"
		ERR_PRINTER_ON_FIRE: return "ERR_PRINTER_ON_FIRE"
		_: return "Unknown error"
