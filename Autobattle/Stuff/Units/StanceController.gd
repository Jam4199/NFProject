extends Node
class_name StanceController

var unit = Unit
var stances : Array = []
var current_stance : Stance :get = get_current_stance


func _ready() -> void:
	for child in get_children():
		if child is Stance:
			stances.append(child)
	if  stances.size() == 0:
		print("NO STANCES AAAAAAAAAAA")
	else:
		
		current_stance = stances[0]
		


func get_current_stance():
	if current_stance == null:
		print("NO STANCE AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		return Stance.new()
	return current_stance

func can_attack() -> bool:
	return get_current_stance().basic_attack.can_attack()

func can_attack_unit(target : Unit) -> bool:
	return get_current_stance().basic_attack.can_attack_unit(target)

#func change_stance(new_stance : Stance):
#	unequip_stance(current_stance)
#	equip_stance(new_stance)
#	current_stance = new_stance
#
#func unequip_stance(stance : Stance):
#	return
#
#func equip_stance(stance : Stance):
#	return

func get_stat_adds(stat : String, stat_adds : Array):
	match stat:
		"attack":
			stat_adds.append(current_stance.attack_add)
		"defense":
			stat_adds.append(current_stance.defense_add)
		"max_health_add":
			stat_adds.append(current_stance.max_health_add)
	if current_stance.custom_stat_adds.has(stat):
		stat_adds.append(current_stance.custom_stat_adds[stat])
	return

func get_stat_mults(stat : String, stat_mults : Array):
	match stat:
		"move_speed":
			stat_mults.append(current_stance.move_speed_mult)
		"attack_speed":
			stat_mults.append(current_stance.attack_speed_mult)
		"attack":
			stat_mults.append(current_stance.attack_mult)
		"defense":
			stat_mults.append(current_stance.defense_mult)
		"max_health":
			stat_mults.append(current_stance.max_health_mult)
		"cold_res":
			stat_mults.append(current_stance.cold_res)
		"fire_res":
			stat_mults.append(current_stance.fire_res)
		"elec_res":
			stat_mults.append(current_stance.elec_res)
	if current_stance.custom_stat_mults.has(stat):
		stat_mults.append(current_stance.custom_stat_mults[stat])
	return

func call_passives(passive_list : Array):
	for passive in get_current_stance().passives:
		passive_list.append(passive)


