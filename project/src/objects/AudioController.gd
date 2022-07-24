extends Node

onready var music_player := $MusicPlayer as AudioStreamPlayer



func _ready() -> void:
	music_player.stream = Preloader.test_music
	music_player.play()


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed(Config.BUTTONS.ENTER)):
		play_sound(_get_random_sound())


func play_sound(sound: AudioStream):
	var sound_player: AudioStreamPlayer = Preloader.sound_player.instance()
	sound_player.stream = sound
	sound_player.volume_db = -1.0
	self.add_child(sound_player)


func _get_random_sound() -> AudioStream:
	randomize()
	var array = [Preloader.test_sound1, Preloader.test_sound2, Preloader.test_sound3, Preloader.test_sound4]
	return array[randi() % 4]
