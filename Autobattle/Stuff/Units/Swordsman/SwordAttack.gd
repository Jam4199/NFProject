extends Action

func action_body(target : Unit):
	play_animation(action_anim)
	var new_damage = sample_damage.duplicate()
	new_damage.source = user
	new_damage.damage_value += userstat().attack
	apply_damage(new_damage, target)

