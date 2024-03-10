extends Node2D
class_name WeaponManager

var weapons : Array[Weapon] = [null,null,null]

var equipped_slot : int = 0

func _ready() -> void:
	default_equip()

func default_equip():
	var slot_queue : int = 0
	for child in get_children():
		if child is Weapon:
			weapons[slot_queue] = child
			slot_queue += 1
			reset_weapon(child)
			if slot_queue >= 3:
				break

func reset_weapon(weapon : Weapon, reload : bool = true):
	weapon.reset(reload)

func change_weapon(slot : int):
	weapons[equipped_slot].player_shoot = false
	if slot < 0:
		slot = 2
	if slot > 2:
		slot = 0
	if slot == equipped_slot:
		return
	if weapons[slot] == null:
		return
	equipped_slot = slot

func weapon_left():
	var new_slot : int = equipped_slot - 1
	if new_slot < 0:
		new_slot = 2
	var anti_loop : int = 0
	while weapons[new_slot] == null:
		new_slot -= 1
		if new_slot < 0:
			new_slot = 2
		anti_loop += 1
		if anti_loop == 10:
			return
	change_weapon(new_slot)

func add_weapon(weapon_scene : PackedScene) -> Weapon:
	var new_slot : int = 0
	for wep in weapons:
		if wep == null:
			break
		new_slot += 1
	if new_slot >= 3:
		print("weapons full " + str(weapons))
		return null
	var new_weapon : Weapon = weapon_scene.instantiate()
	add_child(new_weapon)
	weapons[new_slot] = new_weapon
	change_weapon(new_slot)
	return new_weapon

func weapon_right():
	var new_slot : int = equipped_slot + 1
	if new_slot > 2:
		new_slot = 0
	var anti_loop : int = 0
	while weapons[new_slot] == null:
		new_slot += 1
		if new_slot > 2:
			new_slot = 0
		anti_loop += 1
		if anti_loop == 10:
			return
	change_weapon(new_slot)

func attack(input : bool):
	if weapons[equipped_slot] == null:
		return
	weapons[equipped_slot].player_shoot = input








