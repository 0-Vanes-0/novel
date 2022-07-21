extends Node

onready var musicPlayer := $MusicPlayer



func _ready() -> void:
	musicPlayer.stream = Preloader.testMusic
	musicPlayer.play()


func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_accept")):
		playSound(getRandomSound())


func playSound(sound : AudioStream):
	var soundPlayer : AudioStreamPlayer = Preloader.soundPlayer.instance()
	soundPlayer.stream = sound
	soundPlayer.volume_db = -1.0
	self.add_child(soundPlayer)


func getRandomSound() -> AudioStream:
	randomize()
	var array = [Preloader.testSound1, Preloader.testSound2, Preloader.testSound3, Preloader.testSound4]
	return array[randi() % 4]
