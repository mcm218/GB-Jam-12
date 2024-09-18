extends Node

@export var pauser: Node
@export var shaker: Node
@onready var blackout: Sprite2D = $Blackout
@onready var particles: CPUParticles2D = $Particles
@export var blackout_duration: float = 5.0
@export var time_till_blackout: float = 5.0
@export var next_scene: PackedScene

var time_till_scene_transition: float = 2.0

var counter: float = 0.0
var is_complete: bool = false
var is_ending: bool = false


func _ready():
	blackout.visible = true
	blackout.modulate.a = 1


func _process(delta):
	if is_ending:
		counter += delta
		if counter >= time_till_blackout and blackout.modulate.a != 1:
			blackout.modulate.a = 1
		elif counter >= time_till_blackout + time_till_scene_transition:
			print_debug("transitioning")
			get_tree().change_scene_to_packed(next_scene)
	
	counter += delta
	if is_complete: return
		
	if blackout.modulate.a < 0.5 and pauser.is_paused:
		pauser.play()
		
	blackout.modulate.a = max(0,(1 - (counter / blackout_duration)))
	
	if blackout.modulate.a == 0:
		is_complete = true


func _on_cutscene_trigger_body_entered(body):
	if body.is_in_group("player"):
		pauser.pause()
		shaker.play()
		particles.emitting = true
		counter = 0.0
		is_ending = true
