extends Control

@export var question = {}

@onready var question_title = $Title
@onready var question_options_control = $QuestionOptions
@onready var checkbox_custom_theme = preload("res://themes/checkbox.tres")
@onready var checkbox_scene = preload("res://modules/checkbox/check_box.tscn")

signal select_option(option)

var checkbox_spacing = 30

func _ready() -> void:
	if question:
		var question_object = question[0]
		question_title.text = question_object.question
		question_title.autowrap_mode = true
		
		clear_children()
		
		if question_object.options:
			for i in range(question_object.options.size()):
				create_option_checkbox(question_object.options[i], i)
				
func create_option_checkbox(option: Dictionary, index: int) -> void:
	var checkbox = checkbox_scene.instantiate()
	
	checkbox.text = option["text"]
	checkbox.option = option
	checkbox.set_meta("is_correct", option["is_correct"])
	checkbox.position = Vector2(0, index * checkbox_spacing)
	checkbox.custom_minimum_size = Vector2(50, 0)
	checkbox.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	checkbox.custom_minimum_size = Vector2(250, 0)
	checkbox.theme = checkbox_custom_theme
	checkbox.connect('select_option', _on_select_option)
#
	question_options_control.add_child(checkbox)

func clear_children():
	for child in question_options_control.get_children():
		question_options_control.remove_child(child)
		child.queue_free()
		
	
func _on_select_option(option):
	#option.disabled = true
	select_option.emit(option)
