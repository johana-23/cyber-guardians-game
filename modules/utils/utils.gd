extends Node

var questions_data_path = 'res://data/questions.json'
var player_variations_path = 'res://data/player_varations.json'
var game_state_path = 'res://data/game_state.json'
var last_level: int = 5
var dialog = preload("res://modules/dialog/dialog.tscn")
var api_url: String = 'https://cyber-guardians-api.onrender.com'

func get_question_number(question_name: String) -> int:
	var question_name_parts: Array = question_name.split('_')
	var question_number = int(question_name_parts[1])
	
	return question_number
	
	
func read_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var content = FileAccess.open(file_path, FileAccess.READ)
		var data = JSON.parse_string(content.get_as_text())
		
		return data
	else:
		print("File doesn't  exists")
	
		
func get_question(level: int, question_number: int) -> Array:
	var questions = read_file(questions_data_path)

	return questions.filter(func(question): return question.level == level and question.number == question_number)
	
	
func get_player_variations() -> Array:
	var player_variations = read_file(player_variations_path)
	
	return player_variations
	
		
func convertHexToVector(hexColor: String) -> Vector3:
	if hexColor.begins_with('#'):
		hexColor = hexColor.substr(1)
	
	var r = hexColor.substr(0,2).hex_to_int() / 255.0
	var g = hexColor.substr(2,2).hex_to_int() / 255.0
	var b = hexColor.substr(4,2).hex_to_int() / 255.0

	return Vector3(r,g,b)

func transition():
	TransitionScreen.transition()
	await TransitionScreen.transition_finished
	
func get_unlocked_levels(level: int):
	var unlocked_levels: Array = []

	for previous_level in range(level):
		unlocked_levels.append(previous_level)
		
	print(unlocked_levels)
	
func show_dialog(text: String):
	var dialog = dialog.instantiate()
	dialog.text = text
	
	add_child(dialog)


func simulate_window_resize():
	# Get the current window size using the viewport
	var viewport = get_viewport()
	var original_size = viewport.size

	# Temporarily resize the window slightly larger
	viewport.size = Vector2(original_size.x, original_size.y) + Vector2(1, 1)

	# Restore the original size after a short delay
	call_deferred("restore_window_size", original_size)

func restore_window_size(original_size: Vector2):
	get_viewport().size = original_size
	
func play_music(file_path: String, is_start_music: bool = false) -> void:
	AudioPlayer.stop()
	AudioPlayer.play(file_path)

func is_start_music_player() -> bool:
	return AudioPlayer.is_start_music

func set_is_start_music(is_start_music: bool) -> void:
	AudioPlayer.is_start_music = is_start_music
