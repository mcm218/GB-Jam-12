extends Node

@export var pauser: Node
@onready var blackout: Sprite2D = $Blackout
@export var blackout_duration: float = 5.0
@export var next_scene: PackedScene

var time_till_scene_transition: float = 2.0

var counter: float = 0.0
var is_complete: bool = false

func _ready():
	print_debug("transitioning")
	blackout.visible = true
	blackout.modulate.a = 1


func _process(delta):
	counter += delta
	if is_complete: return
		
	if blackout.modulate.a < 0.5 and pauser.is_paused:
		pauser.play()
		
	blackout.modulate.a = max(0,(1 - (counter / blackout_duration)))
	
	if blackout.modulate.a == 0:
		is_complete = true
