extends Node2D

@export var test_weapon : Weapon

func _ready() -> void:
	test_weapon.update_stats()
	test_weapon.ammo = test_weapon.magazine_size

func _physics_process(delta: float) -> void:
	if test_weapon == null:
		return
	test_weapon.player_shoot = true
