extends Node

# ---------- VARIABLES ----------

var isGamePaused : bool
var screenWidth : float 
var screenHeight : float
var buttonHeight : float

func _ready() -> void:
	screenWidth = get_viewport().get_visible_rect().size.x
	screenHeight = get_viewport().get_visible_rect().size.y
	Global.printInfo([self, "screenWidth=", screenWidth, " screenHeight=", screenHeight])
	
	buttonHeight = screenHeight / 10
	isGamePaused = false

# ---------- FUNTIONS ----------

func findNodeByName(name, root : Node = get_tree().current_scene):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = findNodeByName(name, child)
		if(found): return found
	printError([self, "Node ", name, " not found"])
	return null


func printInfo(arr : Array): # FIRST ELEMENT IS ALWAYS "SELF"!!!
	var file = (arr.front() as Node).get_path()
	arr.pop_front()
	var text = PoolStringArray(arr).join("")
	var time := OS.get_time()
	var hours = time.hour; var minutes = time.minute; var seconds = time.second
	var millis = OS.get_ticks_msec() % 1000
	if(hours < 10):
		hours = "0" + String(hours)
	if(minutes < 10):
		minutes = "0" + String(minutes)
	if(seconds < 10):
		seconds = "0" + String(seconds)
	if(millis < 10):
		millis = "00" + String(millis)
	elif(millis < 100):
		millis = "0" + String(millis)
	print("INFO ", hours, "-", minutes, "-", seconds, "-", millis, " ", file, " >>>>> ", text)


func printError(arr : Array): # FIRST ELEMENT IS ALWAYS "SELF"!!!
	var file := (arr.front() as Node).get_path()
	arr.pop_front()
	var text = PoolStringArray(arr).join("")
	var time := OS.get_time()
	var hours = time.hour; var minutes = time.minute; var seconds = time.second
	var millis = OS.get_ticks_msec() % 1000
	if(hours < 10):
		hours = "0" + String(hours)
	if(minutes < 10):
		minutes = "0" + String(minutes)
	if(seconds < 10):
		seconds = "0" + String(seconds)
	print("ERROR ", hours, "-", minutes, "-", seconds, "-", millis, " ", file, " >>>>> ", text)


func getCurrentScene() -> Node:
	return get_tree().current_scene


func goToScene(scene : PackedScene):
	return get_tree().change_scene_to(scene)


func resumeGame(pauseMenu : Control):
	pauseMenu.hide()
	get_tree().paused = false
	isGamePaused = false


func pauseGame(pauseMenu : Control):
	pauseMenu.show()
	get_tree().paused = true
	isGamePaused = true
