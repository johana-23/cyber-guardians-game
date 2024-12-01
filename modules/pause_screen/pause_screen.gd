extends Control

signal continue_pressed
signal back_pressed

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('pause'):
		_on_continue_pressed()

func _on_continue_pressed() -> void:
	continue_pressed.emit()


func _on_back_pressed() -> void:
	back_pressed.emit()
