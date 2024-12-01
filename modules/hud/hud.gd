extends Node

@onready var timer = $TimerContainer/Timer
@onready var timer_label = $TimerContainer/Label
@onready var lives_label = $LiveContainer/Lives
@onready var score_label = $Score

@export var total_time: int
@export var score: int
@export var lives: int

signal timer_timeout	

func _ready() -> void:	
	init_timer_hud()
	init_score_hud()
	init_lives_hud()
	start_timer()

func _process(delta: float) -> void:
	init_timer_hud()
	
	
func init_timer_hud():
	timer.wait_time = total_time
	timer_label.text = str(total_time)
	
	var time_left = int(timer.time_left)
	timer_label.text = str(time_left)
	
	if time_left == 0:
		timer_label.text = '¡Se acabó el tiempo!'
		
func init_score_hud():
	score_label.text = 'Puntaje: ' + str(score)
	
func init_lives_hud():
	lives_label.text = 'X ' + str(lives)
		
func start_timer():
	timer.connect('timeout', _on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	emit_signal('timer_timeout')

func update_score(new_score: int) -> void:
	score = new_score
	score_label.text = 'Puntaje: ' + str(new_score)

func update_lives(new_lives: int) -> void:
	lives = new_lives
	lives_label.text = 'X ' + str(lives)
	
func get_elapsed_time():
	return  total_time - timer.time_left
