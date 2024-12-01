extends Node

@onready var is_start_music: bool = false
@onready var player: AudioStreamPlayer = $AudioStreamPlayer
const AUDIO = "res://assets/audio/start.mp3"


#func _ready() -> void:
	#play(AUDIO)

func play(file_path: String) -> void:
	var audio_stream = load(file_path) as AudioStream
	
	if audio_stream:
		player.stream = audio_stream
		player.play()
	else:
		print("Failed to load audio file:", file_path)	

func stop():
	player.stop()
