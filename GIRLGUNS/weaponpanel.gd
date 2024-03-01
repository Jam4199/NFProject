extends Panel
class_name WeaponPanel

@onready var icon : TextureRect = get_node("%Icon")
@onready var weapon_name : RichTextLabel = get_node("%WeaponName")
@onready var ammo : RichTextLabel= get_node("%Ammo")

func equip_change(setting : bool):
	icon.visible = setting

func update(weapon : Weapon):
	if weapon == null:
		return
	#icon.texture = weapon.icon
	weapon_name.text = "[center]" + weapon.ui_name + "[/center]"
	if weapon.ammo > 0:
		ammo.text = "[center]" + str(weapon.ammo) + " / " + str(weapon.magazine_size) + "[/center]"
	else:
		ammo.text = "[center] Recharging [/center]"
	
	return
