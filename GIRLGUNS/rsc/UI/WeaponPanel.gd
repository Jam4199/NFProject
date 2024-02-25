extends Control

@onready var wep0 : WeaponPanel = get_node("%Weapon0")
@onready var wep1 : WeaponPanel = get_node("%Weapon1")
@onready var wep2 : WeaponPanel = get_node("%Weapon2")
@onready var ammo : TextureProgressBar = get_node("%Ammo")
@onready var reload : TextureProgressBar = get_node("%Reload")


var weaponpanels : Array[WeaponPanel] = [wep0,wep1,wep2]

func _ready() -> void:
	weaponpanels = [wep0,wep1,wep2]


func update():
	var weapons : Array[Weapon] = Globals.player.weapon_manager.weapons
	var slot : int = Globals.player.weapon_manager.equipped_slot
	
	for n in range(0,weapons.size()):
		weaponpanels[n].visible = weapons[n] != null
		if n == slot:
			weaponpanels[n].equip_change(true)
		else:
			weaponpanels[n].equip_change(false)
		weaponpanels[n].update(weapons[n])
	
	ammo.max_value = weapons[slot].magazine_size
	ammo.value = weapons[slot].ammo
	reload.max_value = weapons[slot].reload_time
	if ammo.value < ammo.max_value:
		reload.value = weapons[slot].reload_time - weapons[slot].reload_timer
	else:
		reload.value = 0
	
	
