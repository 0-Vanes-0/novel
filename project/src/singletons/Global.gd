extends Node
# This is global script which stores global variables and helps with some global processes
# like pausing game, finding nodes at tree, switching scenes etc.

# ---------- VARIABLES ----------

var player_variables: Dictionary #setget
var is_game_paused: bool
var screen_width: float 
var screen_height: float

func _ready() -> void:
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	Global.info(self, "screen_width=%s, screen_height=%s" % [screen_width, screen_height])
	
	is_game_paused = false

# ---------- FUNTIONS ----------

func find_node_by_name(name, root : Node = get_tree().current_scene):
	if root.get_name() == name: return root
	for child in root.get_children():
		if child.get_name() == name:
			return child
		var found = find_node_by_name(name, child)
		if found: 
			return found
	error("Node %s not found" % name)
	return null


func info(source: Node, message: String):
	var node_path = source.get_path()
	print("    INFO %s >>>>> %s" % [node_path, message])


func error(message: String):
	print("%s at:" % message)
	print_stack()


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
