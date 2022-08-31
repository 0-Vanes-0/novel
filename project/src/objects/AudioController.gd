extends Node

onready var _music_player := $MusicPlayer



func _ready() -> void:
	_music_player.stream = Preloader.musics["test_music"]
	_music_player.volume_db = -10.0
	_music_player.play()


func play_sound(sound: AudioStream):
	var sound_player: AudioStreamPlayer = Preloader.sound_player.instance()
	sound_player.stream = sound
	sound_player.volume_db = -1.0
	self.add_child(sound_player)
