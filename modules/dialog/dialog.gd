extends CanvasLayer

@onready var textbox_container: MarginContainer = $TextBoxContainer
@onready var label: Label = $TextBoxContainer/Panel/MarginContainer/HBoxContainer/Label
@onready var panel: Panel = $TextBoxContainer/Panel

@export var text = ''
@export var duration = 2
@export var dialog_type: String = 'success'

func _ready() -> void:
	label.visible_ratio = 0
	set_panel_border_color()
	add_text(text)
	
	await get_tree().create_timer(duration).timeout
	hide_text_box()
	

	
func show_text_box():
	textbox_container.show()

func hide_text_box():
	label.text = ''
	textbox_container.hide()
	
func add_text(text: String):
	label.text = text
	show_text_box()
	
	var tween = create_tween()
	tween.tween_property(label, 'visible_ratio', 1.0, 1.0)
	
func set_panel_border_color():
	var dialog_border_colors = {
		'normal': Color("#ffffff"), 
		'success': Color("#4bffb4"),
		'error': Color("#d75c5d")
	}

	print(dialog_border_colors[dialog_type])
	var style = StyleBoxFlat.new()
	
	style.border_color = '#ffc'


   
	
	

	
