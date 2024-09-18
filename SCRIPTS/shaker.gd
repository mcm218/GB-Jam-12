extends Node2D

@export var h_amplitude: float = 0.5
@export var h_frequency: float = 1.0

@export var is_active: bool = false

var parent: Node2D

var duration: float = 0

func _ready():
	parent = get_parent()


func play():
	is_active = true
	
func pause():
	is_active = false

func _process(delta):
	if is_active:
		duration += delta
		var offset: float = h_amplitude * sin(duration * h_frequency * TAU)
		parent.position.x += offset * delta
