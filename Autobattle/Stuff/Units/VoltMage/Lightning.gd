extends Action

var special_effect = preload("res://Stuff/Units/VoltMage/LightningBolt.tscn")

func action_body(target : Unit):
	play_animation(action_anim)
	var new_damage = sample_damage.duplicate()
	new_damage.source = user
	new_damage.damage_value += userstat().attack
	apply_damage(new_damage, target)
	
	if special_effect != null:
		var new_VFX = special_effect.instantiate()
		user.field.create_VFX(new_VFX,target.position)
