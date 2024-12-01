extends ParallaxBackground

@export var background_texture: CompressedTexture2D = preload("res://assets/textures/backgrounds/Blue.png")
@export var scroll_speed = 15

@onready var sprite = $ParallaxLayer/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = background_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite.region_rect.position += delta * Vector2(scroll_speed, scroll_speed)

	if(sprite.region_rect.position >= Vector2(64,64)):
		sprite.region_rect.position = Vector2.ZERO                 
		
