class_name ScenePlayer
extends Control

signal scene_finished
signal restart_requested
signal transition_finished

const KEY_END_OF_SCENE := -1
const KEY_RESTART_SCENE := -2

const TRANSITIONS := {
	fade_in = "_appear_async",
	fade_out = "_disappear_async",
}
enum TRANSITION_TYPES {
	TEXTBOX_TRANSITION,
	IMAGE_TRANSITION,
}

var _scene_data := {}

onready var _background := $Background as TextureRect
onready var _text_box := $TextBox as TextBox
onready var _ch_displayer := $CharacterDisplayer as CharacterDisplayer
onready var _anim_player := $AnimationPlayer as AnimationPlayer



func load_scene(dialogue: SceneTranspiler.DialogueTree) -> void:
	# The main script
	_scene_data = dialogue.nodes


func run_scene():
	var key := 0
	while key != KEY_END_OF_SCENE:
		var node: SceneTranspiler.BaseNode = _scene_data[key]
		var character: Character = (
				Preloader.get_character(node.character)
				if "character" in node and node.character != ""
				else Preloader.get_narrator()
		)
		
		# Displaying a character.
		if "character" in node and not character.is_narrator():
			var side: String = (
					node.side 
					if "side" in node and node.side != ""
					else CharacterDisplayer.SIDE.MIDDLE
			)
			var animation: String = node.animation
			var expression: String = node.expression
			_ch_displayer.display(character, side, expression, animation)
			if not "line" in node:
				yield(_ch_displayer, "display_finished")
		
		# Normal text reply.
		if "line" in node:
			if node.line != "":
				_text_box.display(node.line, character.display_name)
				yield(_text_box, "next_requested")
			key = node.next
		
		# Transition animation.
		elif node is SceneTranspiler.TransitionCommandNode:
			if node.transition != "":
				call(TRANSITIONS[node.transition], TRANSITION_TYPES.TEXTBOX_TRANSITION)
				yield(self, "transition_finished")
			key = node.next
		
		# Displaying a background.
		elif node is SceneTranspiler.BackgroundCommandNode:
			var bg_tx: Texture = (
					Preloader.backgrounds[node.background]
					if Preloader.backgrounds.has(node.background)
					else Preloader.backgrounds["no_background"]
			)
			_background.texture = bg_tx
			if node.transition != "":
				call(TRANSITIONS[node.transition], TRANSITION_TYPES.IMAGE_TRANSITION)
				yield(self, "transition_finished")
			key = node.next
		
		# Manage variables.
		elif node is SceneTranspiler.SetCommandNode:
			match node.value:
				"true":
					Global.set_player_variable(node.symbol, true)
				"false":
					Global.set_player_variable(node.symbol, false)
				var exception:
					Global.info(self, "Got command 'set %s %s'" %[node.symbol, exception])
					Global.set_player_variable(node.symbol, exception)
			key = node.next
		
		# Change to another scene.
		elif node is SceneTranspiler.SceneCommandNode:
			if node.scene_path == "next_scene":
				key = KEY_END_OF_SCENE
			else:
				key = node.next # ОБЯЗАТЕЛЬНО ПОНЯТЬ, КАК РАБОТАЕТ!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		# Choices.
		elif node is SceneTranspiler.ChoiceTreeNode:
			Global.info(self, "Entered choice of %s" %[node.choices])
			_text_box.display_choice(node.choices)
			key = yield(_text_box, "choice_made")
			if key == KEY_RESTART_SCENE:
				emit_signal("restart_requested")
				return
		
		# Recognizing conditions.
		elif node is SceneTranspiler.ConditionalTreeNode:
			var variable: bool = Global.get_player_variable(node.if_block.condition.value)
			Global.info(self, "Entered condition %s, equals to %s" 
					%[node.if_block.condition.value, variable])
			
			# Evaluate the if's condition
			if variable == true:
				Global.info(self, "Went to if!!!!!!!!!!!!!!!")
				key = node.if_block.next
			else:
				# Have to use this flag because we can't `continue` out of the elif loop
				var elif_condition_fulfilled := false
				
				# Evaluate the elif's conditions
				for block in node.elif_blocks:
					variable = Global.get_player_variable(block.condition.value)
					if variable == true:
						key = block.next
						elif_condition_fulfilled = true
						break
				
				if not elif_condition_fulfilled:
					if node.else_block:
						# Go to else
						key = node.else_block.next
						Global.info(self, "Went to else!!!!!!!!!!!!!!! key = %s" %key)
					else:
						# Move on
						key = node.next
		
		# Ensures we don't get stuck in an infinite loop if there's no line to display.
		else:
			key = node.next
	
	yield(get_tree().create_timer(1.0), "timeout")
	var label := Label.new()
	label.text = "Сцена закончилась.\nМожно нажать R для перезапуска."
	label.theme = load("res://assets/themes/textbox_theme.tres")
	label.align = Label.ALIGN_CENTER
	label.margin_left = 100.0
	label.margin_top = 100.0
	add_child(label)


# Не забыть MoveCommandNode


func _appear_async(type) -> void:
	if type == TRANSITION_TYPES.TEXTBOX_TRANSITION:
		yield(_text_box.fade_in_async(), "completed")
	elif type == TRANSITION_TYPES.IMAGE_TRANSITION:
		_anim_player.play("fade_in")
		_anim_player.seek(0.0, true)
		yield(_anim_player, "animation_finished")
	else:
		Global.error("Wrong transition type = %s" % type)
	emit_signal("transition_finished")


func _disappear_async(type) -> void:
	if type == TRANSITION_TYPES.TEXTBOX_TRANSITION:
		yield(_text_box.fade_out_async(), "completed")
	elif type == TRANSITION_TYPES.IMAGE_TRANSITION:
		_anim_player.play("fade_out")
		_anim_player.seek(0.0, true)
		yield(_anim_player, "animation_finished")
	else:
		Global.error("Wrong transition type = %s" % type)
	emit_signal("transition_finished")




















