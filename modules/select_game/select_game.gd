extends Control

const START_SCREEN = "res://modules/start_menu/start_menu.tscn"

@onready var games = StateManager.get_games()
@onready var games_container: Control = $ColorRect/GamesContainer


func _ready() -> void:
	for index in games_container.get_child_count():
		var game_selector = games_container.get_child(index)
		var game_data = games[index] if index < games.size() else {}

		game_selector.set_game(game_data)
	


func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(START_SCREEN)
