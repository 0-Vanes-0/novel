# Displays character replies in a dialogue
extends Control

# Emitted when all the text finished displaying.
signal display_finished
# Emitted when the next line was requested
signal next_requested
# Emitted when choice made at ChoiceSelector
signal choice_made(target_id)

# Speed at which the characters appear in the text body in characters per second.
export var display_speed := 20.0

#onready var _skip_button : Button = $SkipButton
onready var _name_label: Label = $NameBackground/NameLabel
onready var _name_background: TextureRect = $NameBackground
onready var _rich_text_label: RichTextLabel = $RichTextLabel
onready var _choice_selector: ChoiceSelector = $ChoiceSelector
onready var _tween: Tween = $Tween
onready var _blinking_arrow: Control = $RichTextLabel/BlinkingArrow
onready var _anim_player: AnimationPlayer = $FadeAnimationPlayer



func _ready() -> void:
	self.hide()
	_blinking_arrow.hide()
	
	_name_label.text = ""
	_rich_text_label.bbcode_text = ""
	_rich_text_label.visible_characters = 0
	
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")
	_choice_selector.connect("choice_made", self, "_on_ChoiceSelector_choice_made")
	
#	_skip_button.connect("timer_ticked", self, "_on_SkipButton_timer_ticked")
	self.show()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Config.BUTTONS.ENTER):
		advance_dialogue()


# Either complete the current line or show the next dialogue line
func advance_dialogue() -> void:
	if _blinking_arrow.visible:
		emit_signal("next_requested")
	else:
		_tween.seek(INF)


func display(text: String, character_name := "", speed := display_speed) -> void:
	if speed != display_speed:
		display_speed = speed
	
	if character_name != Preloader.get_narrator().display_name and character_name != "":
		_name_label.text = character_name
		if not _name_background.visible:
			_name_background.show()
			fade_in_name()
	
	elif _name_background.visible:
		fade_out_name()
		_name_background.hide()
	
	set_bbcode_text(text)


func display_choice(choices: Array) -> void:
#	_skip_button.hide()
	_name_background.hide()
	_rich_text_label.hide()
	_blinking_arrow.hide()
	
	_choice_selector.display(choices)


func set_bbcode_text(text: String) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	_blinking_arrow.hide()
	_rich_text_label.bbcode_text = text
	# Required for the `_rich_text_label`'s  text to update and the code below to work.
	call_deferred("_begin_dialogue_display")


func _begin_dialogue_display() -> void:
	var character_count := _rich_text_label.get_total_character_count()
	_tween.interpolate_property(
		_rich_text_label, 
		"visible_characters", 
		0, 
		character_count, 
		character_count / display_speed
	)
	_tween.start()


func fade_in_async() -> void:
	_anim_player.play("textbox_fade_in")
	_anim_player.seek(0.0, true)
	_rich_text_label.visible_characters = 0
	yield(_anim_player, "animation_finished")


func fade_out_async() -> void:
	_anim_player.play("textbox_fade_out")
	yield(_anim_player, "animation_finished")


func fade_in_name():
	_anim_player.play("namebox_fade_in")
	yield(_anim_player, "animation_finished")


func fade_out_name():
	_anim_player.play("namebox_fade_out")
	yield(_anim_player, "animation_finished")


func _on_Tween_tween_all_completed() -> void:
	emit_signal("display_finished")
	_blinking_arrow.show()


func _on_ChoiceSelector_choice_made(target_id: int) -> void:
	emit_signal("choice_made", target_id)
#	_skip_button.show()
	_name_background.show()
	_rich_text_label.show()


func _on_SkipButton_timer_ticked() -> void:
	advance_dialogue()
