extends CanvasLayer

@export var title_text: String
@export var message_text: String
@export var is_win: bool
@export var level_number: int = 2
@export var score: int
@export var elapsed_time: int
@export var lives: int

@onready var title: Label = $Background/Title
@onready var message: Label = $Background/MessageContainer/Message
@onready var sub_message: Label = $Background/MessageContainer/SubMessage
@onready var coninue_button: Button = $Control/Continue
@onready var score_value: Label = $Background/ResultsContainer/ScoreContainer/Value
@onready var elapsed_time_value = $Background/ResultsContainer/ElapsedTimeContainer/Value
@onready var lives_value = $Background/ResultsContainer/LivesContainer/Value

const START_MENU_SCENE = "res://modules/start_menu/start_menu.tscn"
const CREDITS_SCENE = "res://modules/credits/credits.tscn"
const WIN_AUDIO = "res://assets/audio/win.mp3"
const LOSE_AUDIO = "res://assets/audio/lose.mp3"


func _ready() -> void:
	play_music()	
	init_parameters()
	

func init_parameters():
	if title_text:
		title.text = title_text
		
	if message_text:
		message.text = message_text
	
	if not is_win:
		coninue_button.text = "Reiniciar"
	
	if is_win and level_number == Utils.last_level:
		coninue_button.text = "Ver créditos"
		
	score_value.text = str(score)
	elapsed_time_value.text = str(elapsed_time)
	lives_value.text = str(lives)
	
	print(lives_value.text, "lives")
		

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_menu_pressed() -> void:
	change_to_scene(START_MENU_SCENE)



func _on_continue_pressed() -> void:
	if is_win and level_number < Utils.last_level:
		var level_text = 'level_' + str(level_number + 1)
		var next_level_scene = 'res://modules/' + level_text + '/' + level_text + '.tscn'
		change_to_scene(next_level_scene)
		
	if is_win and level_number == Utils.last_level:
		change_to_scene(CREDITS_SCENE)
		
	if not is_win:
		var level_text = 'level_' + str(level_number)
		var current_level_scene = 'res://modules/' + level_text + '/' + level_text + '.tscn'
		
		change_to_scene(current_level_scene)

func change_to_scene(scene: String):
	await Utils.transition()
	queue_free()
	get_tree().change_scene_to_file(scene)
	
func play_music():
	var file_path = WIN_AUDIO if is_win else LOSE_AUDIO
	Utils.set_is_start_music(false)
	
	Utils.play_music(file_path)
