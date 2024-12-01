extends Node2D

@export var level: int
@export var lives: int = 3
@export var time: int = 80
@export var score: int = 0
@export var score_to_add: int = 100

@onready var player = $Player
@onready var questions = $Questions
@onready var tile_map_layer = $TileMapLayer
@onready var is_question_active = false
@onready var hud = preload("res://modules/hud/hud.tscn") as PackedScene
@onready var http = preload("res://modules/http/http.tscn") as PackedScene
@onready var http_instance = http.instantiate()

const RESULTS_SCREEN_SCENE = "res://modules/results_screen/results_screen.tscn"
const START_SCREEN_SCENE = 'res://modules/start_menu/start_menu.tscn'
var audio: String

var pause_screen = preload("res://modules/pause_screen/pause_screen.tscn")
var results_sceen = preload("res://modules/results_screen/results_screen.tscn")
var question_layer_instance

var hud_instance
var pause_instance
var character_variation
var is_paused: bool = false
signal pause(is_paused: bool)

@onready var retry_dialog = preload("res://modules/dialog/dialog.tscn") as PackedScene


func _ready():	
	Utils.simulate_window_resize()
	play_music()
	get_character()
	hud_instance = hud.instantiate()
	pause.connect(_on_pause)
	
	if StateManager.is_authenticated():
		http_instance.request_completed.connect(_on_request_completed)
		add_child(http_instance)
	
	if is_empty_game():
		create_game()
	
	
	init_timer()
	init_score()
	init_lives()
	
	init_questions()
	add_child(hud_instance)
	

func _process(delta: float):			
	tile_map_layer.visible = !is_question_active
	player.visible = !is_question_active
	player.active = !is_question_active
	
	if Input.is_action_just_pressed('pause') and not is_paused:
		pause.emit(true)
		
		
func _on_open_question(is_open: bool):
	is_question_active = is_open
	
func init_timer():
	hud_instance.total_time = time
	hud_instance.connect('timer_timeout', _on_timeout)
	
func init_score():
	hud_instance.score = score
	
func init_lives():
	hud_instance.lives = lives
	
	
func init_questions():
	for question_point in questions.get_children():		
		question_point.level = level
		question_point.number = Utils.get_question_number(question_point.name)
		question_point.connect('open_question', _on_open_question)
		question_point.connect('select_option', _on_select_option)
		question_point.connect('finish_question', _on_finish_question)
		question_point.connect('show_score', _on_show_score)

		
func _on_timeout():
	show_dialog('¡Se acabó el tiempo!')
	await get_tree().create_timer(2.0).timeout
	show_results_screen('¡Se Agotó El Tiempo!', false, '¡Intentalo De Nuevo!')
	

func _on_select_option(option):
	if option['is_correct']:
		score += score_to_add
		hud_instance.update_score(score)
		
		
	if not option['is_correct']:
		if lives > 0:
			lives -= 1
			hud_instance.update_lives(lives)

		
		if lives <= 0:
			lives = 0
			hud_instance.update_lives(lives)

			await get_tree().create_timer(2.0).timeout
			show_results_screen('¡Has Perdido!', false, '¡Intentalo De Nuevo!')
						
		
func _on_finish_question(question_point):
	question_point.active = false
	
func show_dialog(message: String) -> void:
	var dialog_instance = retry_dialog.instantiate()
	
	dialog_instance.text = message
	add_child(dialog_instance)
	
	
func get_character():
	character_variation = StateManager.get_character_variation()
	var game = StateManager.get_game()
	
	if StateManager.is_authenticated():
		character_variation = StateManager.get_game().character_variation
		
	player.variation = character_variation
	
func show_results_screen(title: String, is_win: bool, message: String):
	await Utils.transition()
	var socre_to_show = score if not StateManager.is_authenticated() else get_total_score()
	
	var root_children = get_tree().root.get_children()
	
	var globals_to_keep = [Utils, State, StateManager, TransitionScreen, AudioPlayer]
	
	for child in root_children:
		if child not in globals_to_keep:
			child.queue_free()
	
	var results_screen_instance = results_sceen.instantiate()
	results_screen_instance.title_text = title
	results_screen_instance.level_number = level
	results_screen_instance.is_win = is_win
	results_screen_instance.message_text = message
	results_screen_instance.score = score
	results_screen_instance.lives = lives
	results_screen_instance.elapsed_time = hud_instance.get_elapsed_time()
	
	get_tree().root.add_child(results_screen_instance)
	queue_free()
	
	
func _on_show_score():
	var unlocked_levels = StateManager.get_unlocked_levels()
	var next_level = level + 1
	var message: String
	unlocked_levels.append(next_level)
	
	StateManager.update_score(score)
	StateManager.update_unlocked_levels(unlocked_levels)
	StateManager.save_game()
	
	if StateManager.is_authenticated():	
		finish_level()
		message = '!Felicidades ' + StateManager.get_user().user_name + '!'
		
	if not StateManager.is_authenticated():
		message = '!Felicidades!'
		
	show_results_screen('Resultados Nivel ' + str(level), true, message)
	
func create_game():
	var game_data = {
		"score": 0,
		"character_variation": character_variation,
		"current_level": 1,
		"levels": [{
			"level": 1,
			"score": 0,
			"elapsed_time": 0
		}]
	}
	
	make_http_request(HTTPClient.Method.METHOD_POST, '/games', game_data)
	
func finish_level():
	var game_data = StateManager.get_game()
	var current_game_level = game_data.levels.filter(func(current_level): return current_level.level == level)
	
	if current_game_level.size() > 0:
		var current_level = current_game_level[0]
		current_level.score = score
		current_level.elapsed_time = get_elapsed_time()
		current_level.lives = lives
	else:
		var level_data =  {
				"level": game_data.current_level ,
				"score": score,
				"elapsed_time": get_elapsed_time(),
				"lives": lives
			}
	
		game_data.levels.append(level_data)
		
	if not is_last_level():
		var next_level_empty = {
			"level": level + 1,
			"score": 0,
			"elapsed_time": 0
		}
		
		game_data.levels.append(next_level_empty)
		
	game_data.current_level = level + 1 if not is_last_level() else Utils.last_level
	
	StateManager.update_game(game_data)
	StateManager.save_game()
	
	game_data.score = get_total_score()
	
	make_http_request(HTTPClient.Method.METHOD_PUT, '/games/' + str(game_data.id), game_data)

	
	
func make_http_request(method: HTTPClient.Method, endpoint: String, body: Dictionary) -> void:
	var headers = ['Authorization: Bearer ' + StateManager.get_auth_token()]
	http_instance.http_method = method
	http_instance.endpoint = endpoint
	
	http_instance.make_request(body, headers)
	
	
func is_empty_game():
	return len(StateManager.get_game()) == 0
	
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var response_string = body.get_string_from_utf8()
	var response_json = JSON.parse_string(response_string)
	
	if response_code != HTTPClient.RESPONSE_OK and response_code != HTTPClient.RESPONSE_CREATED:
		Utils.show_dialog('Ocurrió un error al guardar la partida')
	
		
	var game = response_json.data
	
	StateManager.update_game(game)
	StateManager.save_game()
	
	
func get_elapsed_time() -> int:
	return int(floor(time - hud_instance.timer.time_left))


func get_total_score():
	var total_score = 0
	
	for level in StateManager.get_game().levels:
		total_score += level.score
		
	return total_score

func is_last_level():
	return Utils.last_level == level
	
	
	
func _on_pause(paused: bool):
	is_paused = paused
	
	if is_paused:
		var question_layer = get_tree().get_nodes_in_group("QuestionLayer")
		
		if(len(question_layer) > 0):
			question_layer_instance = question_layer[0]
			question_layer_instance.visible = false
			
		pause_instance = pause_screen.instantiate()
		pause_instance.continue_pressed.connect(_on_continue_pressed)
		pause_instance.back_pressed.connect(_on_back_pressed)
		add_child(pause_instance)
		get_tree().paused = true
		
func _on_continue_pressed():
	pause_instance.queue_free()
	get_tree().paused = false
	is_paused = false
	
	if question_layer_instance:
		question_layer_instance.visible = true
		question_layer_instance = []
	
func _on_back_pressed() -> void:
	get_tree().paused = false
	is_paused = false
	
	await Utils.transition()
	get_tree().change_scene_to_file(START_SCREEN_SCENE)

func play_music():
	var level_text = 'level' + str(level) + '.mp3'
	var file_path = "res://assets/audio/" + level_text
	
	Utils.set_is_start_music(false)
	Utils.play_music(file_path)
	
	
	
