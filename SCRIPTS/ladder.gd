extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_ladder_body_entered)
	connect("body_exited", on_ladder_body_exited)
	
func _on_ladder_body_entered(body):
	if body.is_in_group("can_climb"):
		print_debug("{0} has entered a ladder", [body])
		body.ladders.append(self)


func on_ladder_body_exited(body):
	if body.is_in_group("can_climb"):
		print_debug("{0} has exited a ladder", [body])
		body.ladders.pop_front()
