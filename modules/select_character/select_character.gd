extends ColorRect

@onready var characters_container: HBoxContainer = $CharactersContainer
@onready var button: Button = $Button
@onready var level1_scene = "res://modules/level_1/level_1.tscn"

var character_variaton_selected: int
var characters: Array

func _ready() -> void:
	get_characters()
	init_characters()
	
func _process(delta: float) -> void:
	button.visible = character_variaton_selected >= 1


func _on_player_variation_select(variation: int):
	character_variaton_selected = variation
	update_characters_animations()
	
	var character_area = get_character().get_node("SelectCharacterArea")
	character_area.selected = true
		
	
func init_characters():
	for character in characters:
		character.animation = 'idle'
		var character_area = character.get_node("SelectCharacterArea") as Area2D
		character_area.connect('player_variation_select', _on_player_variation_select)
		
		
func get_characters():
	characters = characters_container.get_children()
	
		
func get_character():
	var character = characters.filter(func(character): return character.variation == character_variaton_selected)
	
	return character[0]
	
func update_characters_animations():
	for character in characters:
		character.animation = 'idle'
		character.get_node("SelectCharacterArea").selected = false
		
	get_character().animation = 'walk'
	

func _on_button_pressed() -> void:
	StateManager.update_character_variation(character_variaton_selected)
	StateManager.save_game()
	
	await Utils.transition()
	get_tree().change_scene_to_file(level1_scene)
