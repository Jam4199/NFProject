extends Weapon
class_name OpheliaWeapon
const OPHELIABULLET : PackedScene = preload("res://rsc/player/weapons/Ophelia/OpheliaBullet.tscn")

@onready var circle : Node2D = get_node("Circle")
@onready var beeg : Node2D = get_node("Beeg")
var spread_shots : int = 8

func _physics_process(delta: float) -> void:
	super(delta)
	circle.rotation_degrees += 360 * delta
	if ammo > 0:
		modulate = Color(0.078, 0.482, 1)
	else:
		modulate = Color(255,255,255)


func shoot():
	var spread_start : float = (spread/2) * spread_shots
	var returned_bullet
	for shot_count in spread_shots:
		var new_bullet = create_bullet(OPHELIABULLET,global_position,global_rotation_degrees - spread_start + (shot_count * spread))
		if roundi(float(spread_shots)/2.0) == shot_count:
			returned_bullet = new_bullet
	return returned_bullet

func blessing(source : int):
	match source:
		Weapon.bless.ASTER:
			magazine_adds += 2
			reload_speed_multiplier += 0.4
			return
		Weapon.bless.LYRIS:
			damage_multiplier += 0.6
			return
		Weapon.bless.OPHELIA:
			return
		Weapon.bless.RUBY:
			aoe_override += 1
			aoe_add += 20
			damage_multiplier += 0.2
			rof_multiplier += 0.2
			spread_add_degrees += 3
			return
		Weapon.bless.VIOLA:
			pierce_add += 1
			rof_multiplier += 0.1
			reload_speed_multiplier += 0.4
			spread_add_degrees += -1
			return
	return
