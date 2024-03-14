extends Main



func _ready() -> void:
	create_new_world(WORLDSCENE)
	create_new_player()
	Globals.world.spawn_player()
	var weapon : Weapon = Globals.player.weapon_manager.add_weapon(load("res://rsc/player/weapons/Aster/AsterWeapon.tscn"))
	weapon.update_stats()
	Globals.player.movement_input = true
	Globals.player.attack_input = true
	Globals.world.world_camera.follow_point = Globals.player
	Globals.world.runprogress.start()
	return

