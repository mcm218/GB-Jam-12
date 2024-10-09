extends CharacterBody2D

@export var speed: float = 0.0
@export var direction: int = 1
@export var _is_paused = false
@export var pixel_snapping = true
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animation.play()
	add_to_group("pausable")
	
func _physics_process(delta):
	if _is_paused:
		return
	print_debug(speed)
	velocity.x = direction * speed * delta
	move_and_slide()
	if pixel_snapping: position = position.snapped(Vector2.ONE)
