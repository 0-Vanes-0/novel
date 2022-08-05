extends Node

onready var music_player := $MusicPlayer as AudioStreamPlayer



func _ready() -> void:
	music_player.stream = Preloader.musics["test_music"]
	music_player.volume_db = -30.0
	if Config.get_setting("Audio", "music_on"):
		music_player.play()


#func _input(event: InputEvent) -> void:
#	if(event.is_action_pressed(Config.BUTTONS.ENTER)):
#		play_sound(_get_random_sound())


func play_sound(sound: AudioStream):
	var sound_player: AudioStreamPlayer = Preloader.sound_player.instance()
	sound_player.stream = sound
	sound_player.volume_db = -10.0
	self.add_child(sound_player)


func _get_random_sound() -> AudioStream:
	randomize()
	var array: Array = Preloader.sounds.values()
	return array[randi() % 4]
