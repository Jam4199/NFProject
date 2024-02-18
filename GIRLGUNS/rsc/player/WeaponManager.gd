extends Node2D
class_name WeaponManager

var weapons : Array[Weapon] = [null,null,null]

var equipped_slot : int = 0

func change_weapon(slot : int):
	if slot < 0:
		slot = 2
	if slot > 2:
		slot = 0
	if slot == equipped_slot:
		return
	if weapons[slot] == null:
		return
	equipped_slot = slot

func attack(input : bool):
	if weapons[equipped_slot] == null:
		return
	weapons[equipped_slot].player_shoot = input








