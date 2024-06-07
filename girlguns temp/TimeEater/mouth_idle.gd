extends EnemyState

var sprite_anim : AnimationPlayer

func state_allow()->bool:
	return true

func state_enter():
	sprite_anim.play("idle")
	unit.toggle(false)
	return

func state_exit():
	unit.toggle(true)
	return

func enemy_ready():
	sprite_anim = get_node("%sprite_anim")
	return

func state_input(input : String):
	match input:
		"launch":
			emit_signal("state_change","mouth_launch")
	return

func state_process(delta : float):
	rotation = 0
	return

