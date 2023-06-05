extends Node

var static_delta : float = 1.0 / 60.0

var worldclicky : Node2D
signal weapon_fire

func weapon_fired():
	emit_signal("weapon_fire")
