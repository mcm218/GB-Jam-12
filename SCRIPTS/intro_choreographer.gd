extends Node

@export var pauser: Node
@export var shaker: Node
@onready var blackout: AnimatedSprite2D = $Blackout
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
	blackout.play("default")

var blackout_triggered = false
func _process(delta):
	if is_ending:
		counter += delta
		if counter >= time_till_blackout and not blackout_triggered:
			blackout.set_frame(0)
			blackout.visible = true
			blackout_triggered = true
		elif blackout_triggered and counter >= time_till_blackout + time_till_scene_transition:
			print_debug("transitioning")
			get_tree().change_scene_to_packed(next_scene)
	
	counter += delta
	if is_complete: return
		
	if blackout.frame > 10 and pauser.is_paused:
		pauser.play()
	
	if blackout.frame >= 23 and blackout.animation_finished:
		print_debug("blackout complete")
		blackout.visible = false
		is_complete = true


func _on_cutscene_trigger_body_entered(body):
	if body.is_in_group("player"):
		print_debug("TRIGGERING ENDING")
		pauser.pause()
		shaker.play()
		particles.emitting = true
		counter = 0.0
		is_ending = true
