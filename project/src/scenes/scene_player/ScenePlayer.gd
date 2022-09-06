class_name ScenePlayer
extends Node
# Loads and plays a scene's dialogue sequences, delegating to other nodes to display images or text.

signal scene_finished
signal restart_requested
signal transition_finished

const KEY_END_OF_SCENE := -1
const KEY_RESTART_SCENE := -2

var _scene_data := {}

onready var _text_box: TextureRect = $TextBox
onready var _character_displayer: CharacterDisplayer = $CharacterDisplayer
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _background: TextureRect = $Background
onready var _restart_label: Label = $RestartLabel



func run_scene() -> void:
	_restart_label.hide()
	var key = 0
	while key != KEY_END_OF_SCENE:
		var node: SceneTranspiler.BaseNode = _scene_data[key]
		var character: Character = (
			Preloader.get_character(node.character)
			if "character" in node and node.character != ""
			else Preloader.get_narrator()
		)
		
		if node is SceneTranspiler.BackgroundCommandNode:
			_background.texture = Preloader.get_background(node.background)
		
		# Displaying a character.
		if "character" in node:
			var expression: String = node.expression
			var animation: String = node.animation
			var side: String = node.side
			_character_displayer.display(character, expression, animation, side)
			if not "line" in node:
				yield(_character_displayer, "display_finished")
		
		# Normal text reply.
		if "line" in node:
			if node.line != "":
				_text_box.display(node.line, character.display_name)
				yield(_text_box, "next_requested")
			key = node.next
		
		# Transition animation.
		elif "transition" in node:
			if node is SceneTranspiler.BackgroundCommandNode:
				match node.transition:
					"fade_in":
						_anim_player.play("fade_in")
						yield(_anim_player, "animation_finished")
					"fade_out":
						_anim_player.play("fade_out")
						yield(_anim_player, "animation_finished")
			if node is SceneTranspiler.TransitionCommandNode:
				match node.transition:
					"fade_in":
						yield(_text_box.fade_in_async(), "completed")
					"fade_out":
						yield(_text_box.fade_out_async(), "completed")
			key = node.next
		
		# Manage variables
#		elif node is SceneTranspiler.SetCommandNode:
#			Variables.add_variable(node.symbol, node.value)
#			key = node.next
		
		# Change to another scene
		elif node is SceneTranspiler.SceneCommandNode:
			if node.scene_path == "next_scene":
				key = KEY_END_OF_SCENE
			else:
				key = node.next
		
		# Choices.
		elif node is SceneTranspiler.ChoiceTreeNode:
			# Temporary fix for the buttons not showing when there are consecutive choice nodes
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			
			_text_box.display_choice(node.choices)
			
			key = yield(_text_box, "choice_made")
			
			if key == KEY_RESTART_SCENE:
				emit_signal("restart_requested")
				return
		
#		elif node is SceneTranspiler.ConditionalTreeNode:
#			var variables_list: Dictionary = Variables.get_stored_variables_list()
#
#			# Evaluate the if's condition
#			if (
#				variables_list.has(node.if_block.condition.value)
#				and variables_list[node.if_block.condition.value]
#			):
#				key = node.if_block.next
#			else:
#				# Have to use this flag because we can't `continue` out of the
#				# elif loop
#				var elif_condition_fulfilled := false
#
#				# Evaluate the elif's conditions
#				for block in node.elif_blocks:
#					if (
#						variables_list.has(block.condition.value)
#						and variables_list[block.condition.value]
#					):
#						key = block.next
#						elif_condition_fulfilled = true
#						break
#
#				if not elif_condition_fulfilled:
#					if node.else_block:
#						# Go to else
#						key = node.else_block.next
#					else:
#						# Move on
#						key = node.next

		# Ensures we don't get stuck in an infinite loop if there's no line to display.
		else:
			key = node.next

	yield(get_tree().create_timer(1.0), "timeout")
	_restart_label.show()
#	emit_signal("scene_finished", "empty_scene") # TODO: get next scene from script!!!


func load_scene(dialogue: SceneTranspiler.DialogueTree) -> void:
	# The main script
	_scene_data = dialogue.nodes
