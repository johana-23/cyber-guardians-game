extends Area2D

signal question_entered(question_id)	

@export var level: int
@export var number: int
@export var active: bool = true
@export var is_last: bool = false

var question_layer = preload("res://modules/question_layer/question_layer.tscn")
var dialog = preload("res://modules/dialog/dialog.tscn")
var question_layer_instance

signal open_question(is_open: bool)
signal select_option(option)
signal finish_question
signal show_score

func _on_body_entered(body: Node2D) -> void:
	if is_last:
		show_score.emit()
		return
	
	if active:
		open_question.emit(true)
		await Utils.transition()

		var question_instance = question_layer.instantiate()
		var question = Utils.get_question(level, number)
		question_layer_instance = question_instance
		
		question_instance.question = question
		question_instance.connect('select_option', _on_select_option)
		
		question_instance.add_to_group("QuestionLayer")
		get_tree().root.add_child(question_instance)
	
func _on_select_option(option):
	var dialog = dialog.instantiate()
	var dialog_text = 'Intenta de nuevo'
	
	if option['is_correct']:
		await Utils.transition()

		question_layer_instance.queue_free()
		open_question.emit(false)
		finish_question.emit(self)
		dialog_text = '¡Respuesta Correcta!'
				
	
	dialog.text = dialog_text
	add_child(dialog)
	
	select_option.emit(option)
	
	
