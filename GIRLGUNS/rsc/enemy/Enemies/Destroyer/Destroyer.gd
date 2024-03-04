extends Enemy

var enraged : bool = false


func take_damage(damage : float):
	if damage_immune:
		damage = 0
	if damage <= 0:
		return
	damaged_effect()
	current_hp -= damage
	if not enraged and current_hp <= (max_hp/2.0):
		enrage()
	if current_hp <= 0:
		death()
	return

func enrage():
	enraged = true
	for state in states:
		if state.has_method("enrage"):
			state.enrage()
	change_state("Enrage")
	return






