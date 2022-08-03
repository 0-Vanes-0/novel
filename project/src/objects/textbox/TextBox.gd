class_name TextBox
extends TextureRect
## Displays character replies in a dialogue

## Emitted when all the text finished displaying.
signal display_finished
## Emitted when the next line was requested
signal next_requested
signal choice_made(target_id)

## Speed at which the characters appear in the text body in characters per second.
export var display_speed := 20.0
export var bbcode_text := "" setget set_bbcode_text

#onready var _skip_button: Button = $SkipButton
onready var _name_background := $NameBox as TextureRect
onready var _name_label := $NameBox/Label as Label
onready var _rich_text_label := $RichTextLabel as RichTextLabel
onready var _blinking_arrow := $RichTextLabel/Arrow as Control
onready var _choice_selector := $ChoiceSelector as ChoiceSelector
onready var _tween := $Tween as Tween
onready var _anim_player := $AnimationPlayer as AnimationPlayer



func _ready() -> void:
	hide()
	_blinking_arrow.hide()
	
	_name_background.hide()
	_name_label.text = ""
	_rich_text_label.bbcode_text = ""
	_rich_text_label.visible_characters = 0
	
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")
	_choice_selector.connect("choice_selected", self, "_on_ChoiceSelector_choice_selected")
	
#	_skip_button.connect("timer_ticked", self, "_on_SkipButton_timer_ticked")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(Config.BUTTONS.ENTER) or event.is_action_pressed(Config.BUTTONS.LMB):
		_advance_dialogue()


# Either complete the current line or show the next dialogue line
func _advance_dialogue() -> void:
	if _blinking_arrow.visible:
		emit_signal("next_requested")
	else:
		_tween.seek(INF)


func display(text: String, character_name := "", speed := display_speed) -> void:
	if character_name == Preloader.get_narrator().display_name:
		if _name_background.visible:
			_anim_player.play("name_box_fade_out")
			yield(_anim_player, "animation_finished")
	elif character_name != "":
		_name_label.text = character_name
		if not _name_background.visible:
			set_bbcode_text("")
			_anim_player.play("name_box_fade_in")
			yield(_anim_player, "animation_finished")
	
	set_bbcode_text(text)
	if speed != display_speed:
		display_speed = speed


func display_choice(choices: Array) -> void:
#	_skip_button.hide()
	if _name_background.visible:
		_anim_player.play("name_box_fade_out")
	_rich_text_label.hide()
	_blinking_arrow.hide()
	_choice_selector.display(choices)


func set_bbcode_text(text: String) -> void:
	bbcode_text = text
	if not is_inside_tree():
		yield(self, "ready")
	
	_blinking_arrow.hide()
	_rich_text_label.bbcode_text = bbcode_text
	# Required for the `_rich_text_label`'s  text to update and the code below to work.
	call_deferred("_begin_dialogue_display")


func _begin_dialogue_display() -> void:
	var character_count := _rich_text_label.get_total_character_count()
	_tween.interpolate_property(
		_rich_text_label, "visible_characters", 0, character_count, character_count / display_speed
	)
	_tween.start()


func fade_in_async() -> void:
	_anim_player.play("fade_in")
	_anim_player.seek(0.0, true)
	yield(_anim_player, "animation_finished")


func fade_out_async() -> void:
	_anim_player.play("fade_out")
	yield(_anim_player, "animation_finished")


func _on_Tween_tween_all_completed() -> void:
	emit_signal("display_finished")
	_blinking_arrow.show()


func _on_ChoiceSelector_choice_selected(target_id: int) -> void:
	emit_signal("choice_made", target_id)
#	_skip_button.show()
#	_name_background.appear()
	_rich_text_label.show()


func _on_SkipButton_timer_ticked() -> void:
	_advance_dialogue()



