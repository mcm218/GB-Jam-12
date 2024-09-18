extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@export var ladders = []
@export var is_player = false

@export var SPEED = 100.0
@export var JUMP_VELOCITY = 0
@export var can_jump = false

var _is_paused: bool = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _is_on_ladder():
	return ladders.size()

func _process(_delta):
	if (not is_player):
		return
		
	if Input.is_action_just_pressed("SELECT"):
		print_debug("select button")
		return

func pause():
	_is_paused = true
func play():
	_is_paused = false

func _physics_process(delta):
	if _is_paused == true: 
		if animatedSprite.animation != "standing":
			animatedSprite.play("standing")
		return
	
	# Add the gravity.
	if not is_on_floor() and not _is_on_ladder():
		velocity.y += gravity * delta

	if not is_player:
		move_and_slide()
		return

	# Handle jump.
	if can_jump and Input.is_action_just_pressed("B") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle action press
	if Input.is_action_just_pressed("A"):
		print_debug("Action button pressed")

	var input = _getMovementInput()
	var direction = input[0]
	var climbing = input[1]
	if direction:
		if not _is_on_ladder(): animatedSprite.play("walking")
		if not _is_on_ladder() and direction < 0 and animatedSprite.flip_h == false:
			animatedSprite.flip_h = true
		elif not _is_on_ladder() and direction > 0 and animatedSprite.flip_h == true:
			animatedSprite.flip_h = false
			
		velocity.x = direction * SPEED * delta
	else:
		if not _is_on_ladder() and animatedSprite.flip_h == true:
			animatedSprite.flip_h = false
		if not _is_on_ladder():
			animatedSprite.play("standing")
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
	if _is_on_ladder() and climbing:
		if animatedSprite.animation != "climbing": 
			animatedSprite.play("climbing")
		if not animatedSprite.is_playing():
			animatedSprite.play("climbing")
		velocity.y = climbing * SPEED * delta
	elif _is_on_ladder():
		if animatedSprite.animation == "climbing" and animatedSprite.is_playing(): animatedSprite.pause()
		velocity.y = move_toward(velocity.x, 0, SPEED * delta)

	move_and_slide()

func _getMovementInput():
	var input = [0,0]
	if Input.is_action_pressed("RIGHT"):     input[0] = 1
	elif Input.is_action_pressed("LEFT"): input[0] = -1
		
	if Input.is_action_pressed("UP"): input[1] = -1
	elif Input.is_action_pressed("DOWN"): input[1] = 1
	return input
