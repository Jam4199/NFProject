extends Node2D
class_name WeaponControl


var weapons : Array = []
var current_equipped : int = 0
@export var swap_disable : float = 1
var current_swap_disable : float = 0

signal weapon_equipped(weapon_slot : int)
signal bullet_made(new_bullet : Bullet)
signal weapon_fired

func _ready() -> void:
	
	for child in get_children():
		if child is Weapon:
			weapons.append(child)
			child.connect("bullet_made", Callable(self,"new_bullet_made"))


func new_bullet_made(new_bullet : Bullet):
	emit_signal("bullet_made", new_bullet)


func fire_weapon(slot : int = 0):
	if slot > weapons.size() - 1:
		print("weapon 404")
		return
	weapons[slot].fire()
	

