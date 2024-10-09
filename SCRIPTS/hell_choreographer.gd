extends Node

@export var pauser: Node
@export var next_scene: PackedScene

var time_till_scene_transition: float = 2.0

var counter: float = 0.0
var is_complete: bool = false
