extends PathFollow2D

@onready var animatedSprite = $AnimatedSprite2D
@export var speed: float = 0.1

var old_pos: Vector2
var _is_paused: bool = false

func _ready():
	old_pos = position
	
func pause():
	_is_paused = true
func play():
	_is_paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _is_paused:
		if animatedSprite.animation != "climbing" and animatedSprite.animation != "standing":
			animatedSprite.play("standing")
		animatedSprite.pause()
		
	if not _is_paused and progress_ratio < 1:
		progress += delta * speed
		_handleDirectionChange()
		old_pos = position


func _handleDirectionChange():
	var direction = position - old_pos
	if direction.y > 0.01 or direction.y < -0.01:
		animatedSprite.play("climbing")
	elif direction.x > 0: # RIGHT
		animatedSprite.play("walking")
		if animatedSprite.flip_h == true: animatedSprite.flip_h = false
	elif direction.x < 0: # LEFT
		animatedSprite.play("walking")
		if animatedSprite.flip_h == false: animatedSprite.flip_h = true
