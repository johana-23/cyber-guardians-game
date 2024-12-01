extends CheckBox

@export var option = ''
@onready var checkbox: CheckBox = $CheckBox

signal select_option(option)

func _ready() -> void:
	connect('toggled', _on_toggled)

func _on_toggled(toggled_on: bool):
	self.disabled  = true
	select_option.emit(option)
	
