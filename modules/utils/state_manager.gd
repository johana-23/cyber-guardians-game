extends Node

const SAVE_FILE_PATH: String = "user://save_game.json"

func _ready() -> void:
	load_game()
		

func save_game() -> void:
	print('save')
	print(State.to_dict())
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		print(State.to_dict())
		var json_string: String = JSON.stringify(State.to_dict())
		file.store_string(json_string)
		file.close()
		print("Game data saved successfully.")
	else:
		print("Failed to open file for saving.")

func load_game() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			file.close()

			if typeof(data) == TYPE_DICTIONARY:
				State.from_dict(data)
				print(data)
				print("Game data loaded successfully.")
			else:
				print("Failed to parse game data. Using default values.")
		else:
			print("Failed to open file for reading.")
	else:
		print("Save file not found. Using default values.")

func get_state() -> Dictionary:
	return State.to_dict()

func get_score() -> int:
	return State.get_score()

func get_unlocked_levels() -> Array:
	return State.get_unlocked_levels()
	
func get_character_variation() -> int:
	return State.get_character_variant()
	
	
func get_auth_token() -> String:
	return State.get_auth_token()
	
func get_user() -> Dictionary:
	return State.get_user()
	
func get_games() -> Array:
	return State.get_games()
	
func get_game() -> Dictionary:
	return State.get_game()


func update_score(score: int) -> void:
	State.set_score(score)

func update_unlocked_levels(levels: Array) -> void:
	State.set_unlocked_levels(levels)
	
func update_character_variation(variation: int) -> void:
	State.set_character_variant(variation)
	
	
func update_auth_token(token: String) -> void:
	State.set_auth_token(token)
		
func update_user(user: Dictionary) -> void:
	State.set_user(user)
	
func update_games(games: Array) -> void:
	State.set_games(games)
	
func update_game(game: Dictionary) -> void:
	State.set_game(game)
	
func is_authenticated():
	return get_auth_token() != '' and get_user() != {}
	
func clear_state():
	State.reset_to_defaults()
	save_game()
