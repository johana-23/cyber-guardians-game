extends Control

@onready var container: Control = $ColorRect/Container
@onready var last_container: Control = $ColorRect/Container/VerticalContainer

const AUDIO = "res://assets/audio/credits.mp3"
const SCROLL_SPEED = 18.0
const START_MENU_SCENE = "res://modules/start_menu/start_menu.tscn"

var is_active: bool = true

func _ready() -> void:
	Utils.set_is_start_music(false)
	Utils.play_music(AUDIO)

func _process(delta: float) -> void:	
	if is_active:	
		var current_position = container.position
		var new_position = Vector2(current_position.x, current_position.y - SCROLL_SPEED * delta)

		container.set_position(new_position)
	

func _on_skip_pressed() -> void:
	await Utils.transition()
	get_tree().change_scene_to_file(START_MENU_SCENE)


func _on_finish_area_area_entered(area: Area2D) -> void:
	is_active = false
