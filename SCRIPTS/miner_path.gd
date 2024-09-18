extends Path2D

@export var speed = 0.1
@export var numSprites = 1
@export var baseNode: PackedScene 
@export var pauser: Node


func _ready():
	if baseNode == null:
		print("Error: baseNode is not set.")
		return
	
	var index = 0.0
	while index < numSprites:
		var follower = _add_sprite(index)
		follower.progress_ratio = index / numSprites
		follower.speed = speed
		print_debug("New miner at %s" % follower.progress_ratio)
		index = index + 1

func _add_sprite(index):
	var new_node = baseNode.instantiate()
	pauser.children.append(new_node)
	if pauser.is_paused:
		new_node.pause()
	add_child(new_node)
	return new_node
