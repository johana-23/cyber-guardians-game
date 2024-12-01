extends CanvasLayer

signal transition_finished	

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
	
func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")
	
func _on_animation_finished(animation_name: String):
	if animation_name == 'fade_to_black':
		transition_finished.emit()
		animation_player.play('fade_to_normal')
		
	if animation_name == 'feed_to_normal':
		color_rect.visible = false
	
	
