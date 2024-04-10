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
	print(str(current_hp))
	return

func enrage():
	print("ENRAGE START")
	enraged = true
	for state in states:
		if states[state].has_method("enrage"):
			states[state].enrage()
	var eye : Node2D = get_node("Flash/Color/Sprite/MainWep/Pupil2/MainEye")
	eye.self_modulate = Color(0.97,0.07,0.03,1.00)
	change_state("Enrage")
	return






