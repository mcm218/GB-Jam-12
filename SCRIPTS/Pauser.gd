extends Node

# TODO: This can prob just be a signal
@export var children: Array[Node] = []

var is_paused = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("START"):
		print_debug("escape pressed")
		if is_paused: play()
		else: pause()
		return
	if is_paused: pause()
	else: play()	
	
	
func pause():
	is_paused = true
	for child in children:
		if child.is_in_group("is_pausable"):
			child.pause()
			
func play():
	is_paused = false
	for child in children:
		if child.is_in_group("is_pausable"):
			child.play()
