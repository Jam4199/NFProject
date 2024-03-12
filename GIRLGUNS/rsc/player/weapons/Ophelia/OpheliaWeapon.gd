extends Weapon
class_name OpheliaWeapon
const OPHELIABULLET : PackedScene = preload("res://rsc/player/weapons/Ophelia/OpheliaBullet.tscn")

@onready var circle : Node2D = get_node("Circle")
@onready var beeg : Node2D = get_node("Beeg")

func _physics_process(delta: float) -> void:
	super(delta)
	circle.rotation_degrees += 360 * delta
	if ammo > 0:
		circle.modulate = Color(1,1,1)
		beeg.modulate = Color(1,1,1)
	else:
		circle.modulate = Color(10,10,10)
		beeg.modulate = Color(10,10,10)

var spread_shots : int = 16

func shoot():
	var spread_start : float = (spread/2) * spread_shots
	var returned_bullet
	for shot_count in spread_shots:
		var new_bullet = create_bullet(OPHELIABULLET,global_position,global_rotation_degrees - spread_start + (shot_count * spread))
		if roundi(float(spread_shots)/2.0) == shot_count:
			returned_bullet = new_bullet
	return returned_bullet
