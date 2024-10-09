extends AnimatedSprite2D

@export var shot: PackedScene
@export var shot_speed: float = 1000.0
@export var shot_direction: int = 1
@export var seconds_per_shot: float = 2
@export var _is_paused = false

var time: float = 0

func _ready():
	add_to_group("pausable")
	
func _process(delta):
	if _is_paused:
		return
		
	time += delta
	if time > seconds_per_shot:
		time = 0.0
		shoot()

func shoot():
	var new_shot = shot.instantiate()
	new_shot.speed = shot_speed
	new_shot.direction = shot_direction
	add_child(new_shot)
	play()
