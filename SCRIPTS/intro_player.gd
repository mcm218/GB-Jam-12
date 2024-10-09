extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@export var ladders = []
@export var is_player = false

@export var SPEED = 100.0
@export var JUMP_VELOCITY = 0
@export var can_jump = false
@export var mining_duration: float = 0.5
@export var pixel_snapping: bool = false

var cur_mining_duration: float = 0.0
@export var _is_paused: bool = false;
@export var has_pickaxe: bool = false;
var has_swung: bool = false;
var initial_hurtbox_x = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum state {
	WALKING,
	JUMPING,
	CLIMBING,
	WALL_HANGING,
	MINING
}

var current_state: state = state.WALKING
		
func _is_on_ladder():
	return ladders.size()
	
func _ready():
	if hurtbox: initial_hurtbox_x = hurtbox.transform.x

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
	
func _find_destructable():
	var bodies = hurtbox.get_overlapping_areas();
	var first_destructable;
	for body in bodies:
		if body.is_in_group("destructable"):
			first_destructable = body
			break
		var parent = body.get_parent()
		if parent and parent.is_in_group("destructable"):
			first_destructable = parent
			break
	return first_destructable

func _physics_process(delta):
	if _is_paused:
		return
		
	# Add the gravity.
	if not is_on_floor() and not _is_on_ladder() and current_state != state.WALL_HANGING:
		velocity.y += gravity * delta

	if not is_player:
		move_and_slide()
		return
		

	var input = _getMovementInput()
	var direction = input[0]
	var climbing = input[1]
	
	_handle_animation(direction, climbing)
		
	if current_state == state.MINING:
		cur_mining_duration += delta
		if animatedSprite.animation_finished:
			if not has_swung:
				has_swung = true
				var destructable = _find_destructable()
				if destructable: destructable.destroy()
			if cur_mining_duration >= mining_duration:
				if is_on_floor(): current_state = state.WALKING
				else: current_state = state.JUMPING
				has_swung = false
		return

	# Handle jump.
	if can_jump and Input.is_action_just_pressed("B") and current_state in [state.WALKING, state.WALL_HANGING]:
		velocity.y = JUMP_VELOCITY
		current_state = state.JUMPING
	if current_state != state.WALL_HANGING:
		if direction != 0:
			velocity.x = direction * SPEED * delta
			if is_on_floor(): current_state = state.WALKING
			else: current_state = state.JUMPING
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		
# CLIMBING
	if _is_on_ladder():
		if climbing != 0:
			current_state = state.CLIMBING
			velocity.y = climbing * SPEED * delta
		elif current_state == state.CLIMBING:
			velocity.y = move_toward(velocity.y, 0, SPEED * delta)
		
	if current_state == state.WALL_HANGING and Input.is_action_just_released("A"):
		current_state = state.JUMPING
		
	# Handle action press
	if has_pickaxe and Input.is_action_just_pressed("A") and not current_state in [state.WALL_HANGING, state.CLIMBING]:
		if is_on_floor() and current_state != state.JUMPING:
			cur_mining_duration = 0.0
			current_state = state.MINING
		elif has_pickaxe:
			if _can_wall_hang(): 
				velocity.y = 0
			current_state = state.WALL_HANGING
			
	move_and_slide()
	if pixel_snapping: position = position.snapped(Vector2.ONE)

func _getMovementInput():
	var input = [0,0]
	if Input.is_action_pressed("RIGHT"):     input[0] = 1
	elif Input.is_action_pressed("LEFT"): input[0] = -1
		
	if Input.is_action_pressed("UP"): input[1] = -1
	elif Input.is_action_pressed("DOWN"): input[1] = 1
	return input

func _on_pickaxe_body_entered(body):
	if hurtbox and body.is_in_group("player"):
		has_pickaxe = true
		print_debug("grabbed pickaxe")
		
		
func _can_wall_hang():
	var bodies = hurtbox.get_overlapping_bodies();
	return bodies.size()
	
func _handle_animation(direction: float, climbing: float):
	if _is_paused == true: 
		if animatedSprite.is_playing(): animatedSprite.pause()
		return
	
# MINING
	if current_state == state.MINING:
		if animatedSprite.animation != "mining": animatedSprite.play("mining")
		return
	
# WALKING
	if current_state == state.WALKING or current_state == state.JUMPING:
		if not _is_on_ladder(): animatedSprite.play("walking")
		if not _is_on_ladder() and direction < 0 and animatedSprite.flip_h == false:
			if hurtbox: hurtbox.transform.x = -initial_hurtbox_x
			animatedSprite.flip_h = true
		elif not _is_on_ladder() and direction > 0 and animatedSprite.flip_h == true:
			if hurtbox: hurtbox.transform.x = initial_hurtbox_x
			animatedSprite.flip_h = false
		if direction == 0: animatedSprite.play("standing")
		return
		
# CLIMBING
	if current_state == state.CLIMBING:
		if animatedSprite.animation != "climbing": animatedSprite.play("climbing")
		if animatedSprite.animation == "climbing" and not animatedSprite.is_playing(): animatedSprite.play()
		if animatedSprite.animation == "climbing" and animatedSprite.is_playing(): animatedSprite.pause()
# WALL HANGING
	if current_state == state.WALL_HANGING:
		if animatedSprite.animation != "wall_hang": animatedSprite.play("wall_hang")
		if not animatedSprite.is_playing() and not _can_wall_hang():
			current_state = state.JUMPING
