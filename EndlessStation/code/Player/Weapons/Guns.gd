extends Weapon

var gun_list : Array

func _ready():
	for child in get_children():
		if child is GunPart:
			gun_list.append(child)

func fire():
	for gun in gun_list:
		gun.fire_bullet()

func add_gun(new_gun : GunPart):
	gun_list.append(new_gun)
	
