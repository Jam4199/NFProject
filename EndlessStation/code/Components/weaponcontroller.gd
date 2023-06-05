extends Node2D
class_name WeaponControl


var weapons : Array = []
var current_equipped : int = 0
@export var swap_disable : float = 1
var current_swap_disable : float = 0

signal weapon_equipped(weapon_slot : int)

signal weapon_fired


func _ready() -> void:
	
	for child in get_children():
		if child is Weapon:
			weapons.append(child)
	
	if weapons.size() > 0:
		current_equipped = 0
		

func _physics_process(delta: float) -> void:
	if current_swap_disable > 0:
		current_swap_disable -= delta


func change_weapon(direction : int):
	if weapons.size() == 0:
		print("no weapon")
		return
	
	current_equipped += direction
	
	if current_equipped < 0:
		current_equipped = weapons.size() - 1
	if current_equipped >= weapons.size():
		current_equipped = 0
	
	current_swap_disable = swap_disable
	emit_signal("weapon_equipped", current_equipped)


func fire_weapon():
	if weapons.size() == 0:
		print("no weapon")
		return
	if current_swap_disable > 0:
		return
	emit_signal("weapon_fired")
	weapons[current_equipped].fire()
	

