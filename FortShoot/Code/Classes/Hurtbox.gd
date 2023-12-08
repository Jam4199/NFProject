extends Area2D
class_name Hurtbox

@export var damage : float = 0


signal hurtbox_hit
signal hit_triggered

func hit(hitbox : HitBox):
	emit_signal("hit_triggered")
	emit_signal("hurtbox_hit", hitbox)

