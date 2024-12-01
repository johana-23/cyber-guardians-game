extends Control

@onready var step1: Control = $Step1
@onready var step2: Control = $Step2
@onready var go_login: Button = $GoLogin
@onready var logout: Button = $Logout
@onready var get_games_request: HTTPRequest = $GetGamesRequest

var isStep1: bool = true

const SELECT_GAME_SCENE = "res://modules/select_game/select_game.tscn"
const LOGIN_SCENE = "res://modules/login/login.tscn"
const REGISTER_SCENE = "res://modules/register/register.tscn"
const SELECT_CHARACTER_SCENE = "res://modules/select_character/select_character.tscn"
const CREDITS_SCENE = "res://modules/credits/credits.tscn"
const AUDIO = "res://assets/audio/start.mp3"


func _ready() -> void:
	play_music()
	
	if is_user_authenticated():
		get_games_request.request_completed.connect(_on_get_games_request_request_completed)
		isStep1 = false
		get_games()
		

	
func _process(delta: float) -> void:
	step1.visible = isStep1
	step2.visible = not isStep1
	
	logout.visible = not isStep1 and is_user_authenticated()
	go_login.visible = not isStep1 and not is_user_authenticated()
	
	if not is_user_authenticated():
		StateManager.clear_state()
	
func _on_new_pressed():
	var next_scene = SELECT_GAME_SCENE if is_user_authenticated() else SELECT_CHARACTER_SCENE
	StateManager.update_score(0)
	StateManager.save_game()
	
	await Utils.transition()
	get_tree().change_scene_to_file(next_scene)


func _on_continue_pressed():
	pass # Replace with function body.

func _on_learn_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()


func _on_login_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(LOGIN_SCENE)
	
	
func _on_guest_pressed() -> void:
	isStep1 = false


func _on_register_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(REGISTER_SCENE)
	
func is_user_authenticated():
	return StateManager.get_auth_token() != ''


func _on_logout_pressed() -> void:
	StateManager.update_auth_token('')
	StateManager.update_user({})
	StateManager.save_game()
	isStep1 = true

func _on_go_login_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(LOGIN_SCENE)
	
func get_games():
	var headers = ['Authorization: Bearer ' + StateManager.get_auth_token()]
	get_games_request.make_request({}, headers)


func _on_get_games_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_string = body.get_string_from_utf8()
	var response_json = JSON.parse_string(response_string)
	var games = response_json.data
	
	StateManager.update_games(games)
	StateManager.save_game()


func _on_credits_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(CREDITS_SCENE)

func play_music():
	if not Utils.is_start_music_player():
		Utils.set_is_start_music(true)
		Utils.play_music(AUDIO)
