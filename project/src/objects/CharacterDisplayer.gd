class_name CharacterDisplayer
extends Node2D
## Displays and animates [Character] portraits, for example, entering from the left or the right.

## Emitted when the characters finished displaying or finished their animation.
signal display_finished

## Maps animation text ids to a function that animates a character sprite.
const ANIMATIONS := {
	"enter" : "_enter", # Сюдя ТАКЖЕ можно будет добавить другие анимации, например, вздрагивания или тряску
	"leave" : "_leave",
	"move" : "_move",
}
const SIDE := {
	LEFT = "left", 
	MIDDLE_LEFT = "middle_left", 
	MIDDLE = "middle",
	MIDDLE_RIGHT = "middle_right",
	RIGHT = "right",
}
const COLOR_WHITE_TRANSPARENT = Color(1.0, 1.0, 1.0, 0.0)

## Keeps track of the character displayed on either side.
var _displayed_characters: Dictionary = {
	"left" : {
		character = null,
		sprite = null,
		expression = "",
	}, 
	"middle_left" : {
		character = null,
		sprite = null,
		expression = "",
	},
	"middle" : {
		character = null,
		sprite = null,
		expression = "",
	},
	"middle_right" : {
		character = null,
		sprite = null,
		expression = "",
	},
	"right" : {
		character = null,
		sprite = null,
		expression = "",
	},
}
onready var _tween := $Tween as Tween
onready var _left := $Left as Position2D
onready var _middle_left := $MiddleLeft as Position2D
onready var _middle := $Middle as Position2D
onready var _middle_right := $MiddleRight as Position2D
onready var _right := $Right as Position2D
onready var _POSITION2DS := {
	"left": _left,
	"middle_left": _middle_left,
	"middle": _middle,
	"middle_right": _middle_right,
	"right": _right,
}


func _ready() -> void:
	_tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")


func _unhandled_input(event: InputEvent) -> void:
	# If the player presses enter before the character animations ended, we seek to the end.
	if event.is_action_pressed(Config.BUTTONS.ENTER) and _tween.is_active():
		_tween.seek(INF)


func display(character: Character, side: String = SIDE.MIDDLE, expression := "", animation := "") -> void:
#	assert(side in SIDE.values())
	if character == null:
		return
	
	var character_side := _find_displayed_character(character)
	if character_side == "":
		_displayed_characters[side].sprite = _create_sprite(character.get_default_image())
		add_child(_displayed_characters[side].sprite)
		_displayed_characters[side].sprite.hide()
		_displayed_characters[side].character = character
	else:
		side = character_side
	
	if expression != "":
		_displayed_characters[side].expression = expression
	_displayed_characters[side].sprite.texture = character.get_image(_displayed_characters[side].expression)
	_displayed_characters[side].sprite.position = _POSITION2DS.get(side).position
	
	if animation != "":
		call_deferred(ANIMATIONS[animation], side, _displayed_characters[side].sprite)
	
	_displayed_characters[side].sprite.show()


func _create_sprite(texture: Texture) -> Sprite:
	var sprite: Sprite = Sprite.new()
	sprite.texture = texture
	sprite.offset = Vector2(
			sprite.offset.x, 
			sprite.offset.y - texture.get_size().y / 2
	)
	return sprite


func _find_displayed_character(character: Character) -> String:
	for side in _displayed_characters.keys():
		if _displayed_characters[side]["character"] == character:
			return side
	return ""


## Fades in and moves the character to the anchor position.
func _enter(from_side: String, sprite: Sprite) -> void:
	var offset := 200
	match from_side:
		SIDE.LEFT: offset *= -1
		SIDE.MIDDLE_LEFT: offset *= -1
		SIDE.MIDDLE: offset *= -1
		SIDE.MIDDLE_RIGHT: offset *= 1
		SIDE.RIGHT: offset *= 1
		_: offset *= -1
	
	var start := sprite.position + Vector2(offset, 0.0)
	var end := sprite.position

	_tween.interpolate_property(
		sprite, 
		"position", 
		start, 
		end, 
		0.5, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		sprite, 
		"modulate", 
		COLOR_WHITE_TRANSPARENT, 
		Color.white, 
		0.25
	)
	_tween.start()

	# Set up the sprite
	# We don't use Tween.seek(0.0) here since that could conflict with running tweens and make them jitter back and forth
	sprite.position = start
	sprite.modulate = COLOR_WHITE_TRANSPARENT


func _leave(from_side: String, sprite: Sprite) -> void:
	var offset := 200
	match from_side:
		SIDE.LEFT: offset *= -1
		SIDE.MIDDLE_LEFT: offset *= -1
		SIDE.MIDDLE: offset *= -1
		SIDE.MIDDLE_RIGHT: offset *= 1
		SIDE.RIGHT: offset *= 1
		_: offset *= -1

	var start := sprite.position
	var end := sprite.position + Vector2(offset, 0.0)

	_tween.interpolate_property(
		sprite, 
		"position", 
		start, 
		end, 
		0.5, 
		Tween.TRANS_QUINT, 
		Tween.EASE_OUT
	)
	_tween.interpolate_property(
		sprite,
		"modulate",
		Color.white,
		COLOR_WHITE_TRANSPARENT,
		0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT,
		0.25
	)
	_tween.start()
	_tween.seek(0.0)


func _move(to_side: String, sprite: Sprite):
	var start := sprite.position
	var end := (_POSITION2DS.get(to_side) as Position2D).position
	
	_tween.interpolate_property(
		sprite,
		"position",
		start,
		end,
		0.5,
		Tween.TRANS_QUINT,
		Tween.EASE_OUT,
		0.2
	)
	_tween.start()
	_tween.seek(0.0)


func _on_Tween_tween_all_completed() -> void:
	emit_signal("display_finished")

































