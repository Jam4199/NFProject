extends Weapon
const OPHELIABULLET : PackedScene = preload("res://rsc/player/weapons/Ophelia/OpheliaBullet.tscn")
@onready var spawn : Node2D = get_node("Marker2D")

var spread_shots : int = 16

func shoot():
	var spread_start : float = (spread/2) * spread_shots
	var returned_bullet
	for shot_count in spread_shots:
		var new_bullet = create_bullet(OPHELIABULLET,global_position,global_rotation_degrees - spread_start + (shot_count * spread))
		if roundi(float(spread_shots)/2.0) == shot_count:
			returned_bullet = new_bullet
	return returned_bullet
