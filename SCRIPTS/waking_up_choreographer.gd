extends Node

@export var pauser: Node
@onready var blackout: AnimatedSprite2D = $Blackout
@export var blackout_duration: float = 5.0
@export var next_scene: PackedScene

var time_till_scene_transition: float = 2.0

var counter: float = 0.0
var is_complete: bool = false

func _ready():
	print_debug("transitioning")
	blackout.visible = true
	blackout.play("default")


func _process(delta):
	counter += delta
	if is_complete: return
		
	if blackout.frame > 15 and pauser.is_paused:
		pauser.play()
	
	if blackout.frame == 23:
		is_complete = true


func _on_transition_body_entered(body):
	if body.is_in_group("player") and next_scene:
		get_tree().change_scene_to_packed(next_scene)
