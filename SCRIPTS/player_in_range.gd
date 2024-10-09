extends Area2D


@export var player_in_range: bool = false


func _on_body_entered(body):
	if body.is_in_group("player"):
		print_debug("player in range")
		player_in_range = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		print_debug("player out of range")
		player_in_range = false
