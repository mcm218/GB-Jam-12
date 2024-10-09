extends Area2D

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var range: Area2D = $Range
@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var body: StaticBody2D = $Body

var current_frame: int = 0


func _on_body_entered(body):
	if range.player_in_range and body.is_in_group("player"):
		current_frame += 1;
		if current_frame > 3:
			queue_free()
			return
		animator.set_frame(current_frame)

func destroy():
	current_frame += 1;
	if particles: particles.emitting = true
	if current_frame == 3:
		if hitbox: hitbox.queue_free()
		if animator: animator.queue_free()
		if body: body.queue_free()
		return
	if animator: animator.set_frame(current_frame)
