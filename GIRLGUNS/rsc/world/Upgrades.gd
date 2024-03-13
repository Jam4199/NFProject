extends Node


var player_pool : Array[Upgrade] = []
var weapon0_pool : Array[Upgrade] = []
var weapon1_pool : Array[Upgrade] = []
var weapon2_pool : Array[Upgrade] = []
var weapon_pools : Array[Array] = [weapon0_pool,weapon1_pool,weapon2_pool]
var weapon_count : int = 0
var bless_pool : Array[int] = [0,1,2,3,4]
var bless_offered : int = 0

enum bless{ASTER,LYRIS,OPHELIA,RUBY,VIOLA}

@export_group("Player_Pool")
@export var level_per_bless : Array[int] = [3,8,15,25,40]
@export var health_upgrades : int = 5
@export var speed_upgrades : int = 3
@export var iframe_upgrades : int = 2
@export var stamina_upgrades : int = 3

signal upgrade_prepared


func create_weapon_pool(new_weapon,slot):
	if new_weapon is AsterWeapon:
		bless_pool.erase(bless.ASTER)
	if new_weapon is LyrisWeapon:
		bless_pool.erase(bless.LYRIS)
	if new_weapon is OpheliaWeapon:
		bless_pool.erase(bless.OPHELIA)
	if new_weapon is RubyWeapon:
		bless_pool.erase(bless.RUBY)
	if new_weapon is ViolaWeapon:
		bless_pool.erase(bless.VIOLA)
	
	
	for n in new_weapon.upgrade_damage:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " Attack"
		new_upgrade.ui_description = "Increase damage by 20%"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = Upgrade.weapon_stats.DAMAGE
		weapon_pools[slot].append(new_upgrade)
	for n in new_weapon.upgrade_reload:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " Recharge"
		new_upgrade.ui_description = "Increases recharge speed by 20%"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = Upgrade.weapon_stats.RELOAD
		weapon_pools[slot].append(new_upgrade)
	for n in new_weapon.upgrade_rof:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " Attack Speed"
		new_upgrade.ui_description = "Increase Attack Speed by 20%"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = 2
		weapon_pools[slot].append(new_upgrade)
	for n in new_weapon.upgrade_magazine:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " Capacity"
		new_upgrade.ui_description = "Increase capacity by 20%(rounded up)"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = 3
		weapon_pools[slot].append(new_upgrade)
	for n in new_weapon.upgrade_pierce:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " Pierce"
		new_upgrade.ui_description = "Increase pierce count by 3"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = 4
		weapon_pools[slot].append(new_upgrade)
	for n in new_weapon.upgrade_aoe:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = new_weapon.ui_name + " AoE"
		new_upgrade.ui_description = "Increase area of effect radius"
		new_upgrade.weapon_slot = slot
		new_upgrade.type = Upgrade.upgrade_type.WEAPON
		new_upgrade.weapon_upgrade = 5
		weapon_pools[slot].append(new_upgrade)
	return

func create_player_pool():
	for n in health_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = "Max Health Up"
		new_upgrade.ui_description = "Increase Max Health by 20% of base amount"
		new_upgrade.player_upgrade = Upgrade.player_stats.HEALTH
		player_pool.append(new_upgrade)
	for n in speed_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = "Speed Up"
		new_upgrade.ui_description = "Increase Speed by 10% of base amount"
		new_upgrade.player_upgrade = 1
		player_pool.append(new_upgrade)
	for n in iframe_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = "Invulnerability Up"
		new_upgrade.ui_description = "Increase Invulnerable Time after dashing"
		new_upgrade.player_upgrade = 2
		player_pool.append(new_upgrade)
	for n in stamina_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = "Stamina Regen Up"
		new_upgrade.ui_description = "Increase Stamina Regeneration Speed"
		new_upgrade.player_upgrade = 3
		player_pool.append(new_upgrade)

	return

func refill_player_pool():
	for n in health_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name = "Max Health Up"
		new_upgrade.ui_description = "Increase Max Health by 20%"
		new_upgrade.player_upgrade = 0
		player_pool.append(new_upgrade)
	for n in speed_upgrades:
		var new_upgrade : Upgrade = Upgrade.new()
		new_upgrade.ui_name ="Speed Up"
		new_upgrade.ui_description = "Increase Speed by 10%"
		new_upgrade.player_upgrade = 1
		player_pool.append(new_upgrade)



func initialize():
	create_player_pool()
	return


func level_up():
	print("level" + str(Globals.player.current_level))
	Globals.world.call_deferred("pause")
	check_upgrades()
	var upgrade_selections = create_selections()
	Globals.upgrademenu.open_upgrades(upgrade_selections)
	var selected_upgrade : Upgrade = await Globals.upgrademenu.upgrade_selected
	apply_upgrade(selected_upgrade)
	Globals.world.call_deferred("unpause")
	

func check_upgrades():
	if Globals.player.current_level in level_per_bless:
		bless_offered += 1
	
	var weapons_array : Array[Weapon] = Globals.player.weapon_manager.weapons
	for n in range(0,weapons_array.size()):
		if weapons_array[n] == null:
			continue
		if weapon_pools[n] == []:
			create_weapon_pool(weapons_array[n],n)
			weapon_count += 1
			if weapon_count > 3:
				print("wtf weapon count over 3")
				weapon_count = 3
	
	if player_pool.size() < 2:
		refill_player_pool()

func create_selections() -> Array[Upgrade]:
	var upgrade_selection : Array[Upgrade] = []
	upgrade_selection.resize(4)

	#player_pool
	player_pool.shuffle()
	upgrade_selection[0] = player_pool[0]
	if player_pool.size() > 1:
		upgrade_selection[1] = player_pool[1]

	#weapon_pull
	var select_weapon_pools : Array[int] = []
	for n in range(0,weapon_pools.size()):
		if weapon_pools[n].size() > 0:
			select_weapon_pools.append(n)
	if select_weapon_pools.size() > 0:
		if select_weapon_pools.size() == 1:
			var this_pool = weapon_pools[select_weapon_pools[0]]
			this_pool.shuffle()
			upgrade_selection[2] = this_pool[0]
			if this_pool.size() > 1:
				upgrade_selection[3] = this_pool[1]
		if select_weapon_pools.size() >= 2:
			select_weapon_pools.shuffle()
			var this_pool = weapon_pools[select_weapon_pools[0]]
			this_pool.shuffle()
			upgrade_selection[2] = this_pool[0]
			this_pool = weapon_pools[select_weapon_pools[1]]
			this_pool.shuffle()
			upgrade_selection[3] = this_pool[0]
	
	#bless/equip_pool
	var new_upgrade : Upgrade
	if bless_pool.size() > 0 and bless_pool.size() >= 5 - bless_offered:
		print("new bless/wep")
		new_upgrade = Upgrade.new()
		new_upgrade.blessing = bless_pool.pick_random()
		var aaaaaa : int = 0
		for bah in Globals.player.weapon_manager.weapons:
			if bah != null:
				aaaaaa += 1
		if aaaaaa < 3:
			new_upgrade.type = Upgrade.upgrade_type.EQUIP
			match new_upgrade.blessing:
				Upgrade.bless.ASTER:
					new_upgrade.ui_name = "Aster Lights"
					new_upgrade.ui_description = "Fires quick bursts of starlight"
				Upgrade.bless.LYRIS:
					new_upgrade.ui_name = "Lyris' Wrath"
					new_upgrade.ui_description = "A powerful burst of pure magic"
				Upgrade.bless.OPHELIA:
					new_upgrade.ui_name = "Ophelia's Wave"
					new_upgrade.ui_description = "Calls upon powerful wave that pushes enemies away"
				Upgrade.bless.RUBY:
					new_upgrade.ui_name = "Ruby Flames"
					new_upgrade.ui_description = "Summons fireballs that chases enemies"
				Upgrade.bless.VIOLA:
					new_upgrade.ui_name = "Viola's Icicle"
					new_upgrade.ui_description = "Shoots fast icicles that pierces through enemies"
		else:
			new_upgrade.type = Upgrade.upgrade_type.BLESS
			match new_upgrade.blessing:
				Upgrade.bless.ASTER:
					new_upgrade.ui_name = "Aster's Blessing"
					new_upgrade.ui_description = "A blessing of Swiftness"
				Upgrade.bless.LYRIS:
					new_upgrade.ui_name = "Lyris' Blessing"
					new_upgrade.ui_description = "A blessing of Might"
				Upgrade.bless.OPHELIA:
					new_upgrade.ui_name = "Ophelia's Blessing"
					new_upgrade.ui_description = "A blessing of Force"
				Upgrade.bless.RUBY:
					new_upgrade.ui_name = "Ruby's Blessing"
					new_upgrade.ui_description = "A blessing of Devestation"
				Upgrade.bless.VIOLA:
					new_upgrade.ui_name = "Ophelia's Blessing"
					new_upgrade.ui_description = "A blessing of Sharpness"
		if new_upgrade != null:
			upgrade_selection[0] = new_upgrade
	
	
	#filler_pool
	var filler_pool : Array[Upgrade] = []
	new_upgrade = Upgrade.new()
	new_upgrade.ui_name = "Heal"
	new_upgrade.ui_description = "Restores 50% of max HP"
	new_upgrade.type = Upgrade.upgrade_type.FILLER
	new_upgrade.filler_upgrade = new_upgrade.fillers.HEAL
	filler_pool.append(new_upgrade)
	new_upgrade = Upgrade.new()
	new_upgrade.ui_name = "All Spells Damage"
	new_upgrade.ui_description = "Increase damage by 10%"
	new_upgrade.type = Upgrade.upgrade_type.FILLER
	new_upgrade.filler_upgrade = new_upgrade.fillers.DAMAGE
	filler_pool.append(new_upgrade)
	new_upgrade = Upgrade.new()
	new_upgrade.ui_name = "All Spells Recharge"
	new_upgrade.ui_description = "Increase recharge speed by 10%"
	new_upgrade.type = Upgrade.upgrade_type.FILLER
	new_upgrade.filler_upgrade = new_upgrade.fillers.DAMAGE
	filler_pool.append(new_upgrade)
	
	if Globals.player.current_hp < Globals.player.max_hp * 0.4:
		if Globals.rng.randf_range(0,1) > 0.5:
			upgrade_selection[1] = filler_pool[0]
			filler_pool.erase(upgrade_selection[1])
	if upgrade_selection[0].type == upgrade_selection[1].type and upgrade_selection[0].player_upgrade == upgrade_selection[1].player_upgrade:
		upgrade_selection[1] = null
	for n in range(0,upgrade_selection.size()):
		if upgrade_selection[n] == null and filler_pool.size() > 0:
			upgrade_selection[n] = filler_pool.pick_random()
			filler_pool.erase(upgrade_selection[n])
	

	return upgrade_selection


func apply_upgrade(new_upgrade : Upgrade):
	print("upgrade_type " + str(new_upgrade.type) )
	match new_upgrade.type:
		Upgrade.upgrade_type.PLAYER:
			player_upgrade(new_upgrade)
		Upgrade.upgrade_type.WEAPON:
			weapon_upgrade(new_upgrade)
		Upgrade.upgrade_type.EQUIP:
			add_weapon(new_upgrade)
		Upgrade.upgrade_type.BLESS:
			bless_upgrade(new_upgrade)
		Upgrade.upgrade_type.FILLER:
			filler_upgrade(new_upgrade)
	return

func player_upgrade(new_upgrade : Upgrade):
	match new_upgrade.player_stats:
		Upgrade.player_stats.HEALTH:
			Globals.player.max_hp += 200
			Globals.player.current_hp += 200
		Upgrade.player_stats.SPEED:
			Globals.player.speed += 30
		Upgrade.player_stats.IFRAME:
			Globals.player.dash_invul += 0.1
		Upgrade.player_stats.STAMINA:
			Globals.player.dash_charge_multiplier += 0.2
	player_pool.erase(new_upgrade)

func weapon_upgrade(new_upgrade : Upgrade):
	match new_upgrade.weapon_upgrade:
		Upgrade.weapon_stats.DAMAGE:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].damage_multiplier += 0.2
		Upgrade.weapon_stats.RELOAD:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].reload_speed_multiplier += 0.2
		Upgrade.weapon_stats.ROF:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].rof_multiplier += 0.2
		Upgrade.weapon_stats.MAGAZINE:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].magazine_adds += ceili(float(Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].base_magazine_size) * 0.2) + 1
		Upgrade.weapon_stats.PIERCE:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].pierce_add += 3
		Upgrade.weapon_stats.AOE:
			Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].aoe_add += 10
	Globals.player.weapon_manager.weapons[new_upgrade.weapon_slot].update_stats()
	weapon_pools[new_upgrade.weapon_slot].erase(new_upgrade)
	print("weapon slot is " + str(new_upgrade.weapon_slot))

func add_weapon(new_upgrade : Upgrade):
	var weapon_scene : PackedScene
	match new_upgrade.blessing:
		new_upgrade.bless.ASTER:
			weapon_scene = load("res://rsc/player/weapons/Aster/AsterWeapon.tscn")
		new_upgrade.bless.LYRIS:
			weapon_scene = load("res://rsc/player/weapons/Lyris/LyrisWeapon.tscn")
		new_upgrade.bless.OPHELIA:
			weapon_scene = load("res://rsc/player/weapons/Ophelia/OpheliaWeapon.tscn")
		new_upgrade.bless.RUBY:
			weapon_scene = load("res://rsc/player/weapons/Ruby/RubyWeapon.tscn")
		new_upgrade.bless.VIOLA:
			weapon_scene = load("res://rsc/player/weapons/Viola/ViolaWeapon.tscn")
	var weapon = Globals.player.weapon_manager.add_weapon(weapon_scene)
	if weapon == null:
		print("oh fuck no weapon")
	else:
		weapon.update_stats()
	bless_pool.erase(new_upgrade.blessing)

func bless_upgrade(new_upgrade : Upgrade):
	
	for weapon in Globals.player.weapon_manager.weapons:
		if weapon == null:
			continue
		weapon.blessing(new_upgrade.blessing)
	bless_pool.erase(new_upgrade.blessing)

func filler_upgrade(new_upgrade : Upgrade):
	match new_upgrade.filler_upgrade:
		Upgrade.fillers.HEAL:
			Globals.player.heal(50)
		Upgrade.fillers.DAMAGE:
			for weapon in Globals.player.weapon_manager.weapons:
				if weapon == null:
					continue
				weapon.damage_multiplier += 0.1
				weapon.update_stats()
		Upgrade.fillers.RECHARGE:
			for weapon in Globals.player.weapon_manager.weapons:
				weapon.reload_speed_multiplier += 0.1
				weapon.update_stats()
			





	
	
