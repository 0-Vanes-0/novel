extends Node

# ---------- VARIABLES ----------

var is_game_paused : bool
var screen_width : float 
var screen_height : float
var button_height : float

func _ready() -> void:
	screen_width = get_viewport().get_visible_rect().size.x
	screen_height = get_viewport().get_visible_rect().size.y
	Global.info([self, "screen_width=", screen_width, " screen_height=", screen_height])
	
	button_height = screen_height / 10
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
	error([self, "Node ", name, " not found"])
	return null


func info(arr : Array): # FIRST ELEMENT IS ALWAYS "SELF"!!!
	var file = (arr.front() as Node).get_path()
	arr.pop_front()
	var text := PoolStringArray(arr).join("")
	var time := OS.get_time()
	var hours = time.hour; var minutes = time.minute; var seconds = time.second
	var millis = OS.get_ticks_msec() % 1000
	if hours < 10:
		hours = "0" + String(hours)
	if minutes < 10:
		minutes = "0" + String(minutes)
	if seconds < 10:
		seconds = "0" + String(seconds)
	if millis < 10:
		millis = "00" + String(millis)
	elif millis < 100:
		millis = "0" + String(millis)
	print("INFO ", hours, "-", minutes, "-", seconds, "-", millis, " ", file, " >>>>> ", text)


func error(arr : Array): # FIRST ELEMENT IS ALWAYS "SELF"!!!
	var file := (arr.front() as Node).get_path()
	arr.pop_front()
	var text := PoolStringArray(arr).join("")
	var time := OS.get_time()
	var hours = time.hour; var minutes = time.minute; var seconds = time.second
	var millis = OS.get_ticks_msec() % 1000
	if hours < 10:
		hours = "0" + String(hours)
	if minutes < 10:
		minutes = "0" + String(minutes)
	if seconds < 10:
		seconds = "0" + String(seconds)
	if millis < 10:
		millis = "00" + String(millis)
	elif millis < 100:
		millis = "0" + String(millis)
	print("ERROR ", hours, "-", minutes, "-", seconds, "-", millis, " ", file, " >>>>> ", text)


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
