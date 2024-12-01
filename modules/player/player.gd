extends CharacterBody2D

class_name Player

@onready var animated_sprite = $AnimatedSprite2D

@export var speed = 50
@export var active = true
@export var variation = 1
@export var animation: String

var variations = {}

func _ready():
	update_character_variation()
		
		
func _physics_process(delta):
	update_character_variation()
	
	if active:
		move_player()
		
func _process(delta: float) -> void:
	if animation:
		animated_sprite.play(animation)

func move_player():
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	update_animation()
	
	move_and_slide()

func update_animation():
	if velocity == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
		
func update_character_variation():
	if variation >= 1:
		variations = Utils.get_player_variations()
		set_color()
		
func set_color():
	var original_material = animated_sprite.material as ShaderMaterial
	var shader_material = original_material.duplicate() as ShaderMaterial
	
	animated_sprite.material = shader_material
	
	var default_variation = variations.filter(func(value): return value.id == 1)
	var requested_variation = variations.filter(func(value): return value.id == variation )
	
	var default_primary_color_vector = Utils.convertHexToVector(default_variation[0].primary)
	var default_secondary_color_vector = Utils.convertHexToVector(default_variation[0].secondary)
	var requested_primary_color_vector = Utils.convertHexToVector(requested_variation[0].primary)
	var requested_secondary_color_vector = Utils.convertHexToVector(requested_variation[0].secondary)


	shader_material.set_shader_parameter("target_color1", default_primary_color_vector)
	shader_material.set_shader_parameter("target_color2", default_secondary_color_vector)
	shader_material.set_shader_parameter("replacement_color1", requested_primary_color_vector)
	shader_material.set_shader_parameter("replacement_color2", requested_secondary_color_vector)
	shader_material.set_shader_parameter("tolerance", 0.2)
