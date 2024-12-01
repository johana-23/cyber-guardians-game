extends Area2D

@onready var player_variation: int
@onready var line_2d: Line2D = $Line2D 

@export var selected: bool = false

signal player_variation_select(variation: int)

func _ready() -> void:
	if get_parent() is Player:
		player_variation = get_parent().variation
		
func _process(delta: float) -> void:
	line_2d.visible = selected

	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		player_variation_select.emit(player_variation)
