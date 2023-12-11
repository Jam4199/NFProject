extends Node2D
class_name StanceManager

var unit = Character
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
	return get_current_stance().can_attack()

func can_attack_unit(target : Character) -> bool:
	return get_current_stance().can_attack_unit(target)


func change_stance(new_stance : Stance):
	unequip_stance(current_stance)
	equip_stance(new_stance)
	current_stance = new_stance

func unequip_stance(stance : Stance):
	return

func equip_stance(stance : Stance):
	return

func control():
	get_current_stance().controller.update()

func get_stat_adds(stat : String, stat_adds : Array):
	if current_stance.stat_adds.has(stat):
		stat_adds.append(current_stance.custom_stat_adds[stat])
	return

func get_stat_mults(stat : String, stat_mults : Array):
	if current_stance.stat_mults.has(stat):
		stat_mults.append(current_stance.custom_stat_mults[stat])
	return

func call_passives(passive_list : Array):
	for passive in get_current_stance().passives:
		passive_list.append(passive)


