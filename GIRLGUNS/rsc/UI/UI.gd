extends Control

@onready var statuspanel = get_node("%StatusPanel") 
@onready var weaponpanel = get_node("%WeaponPanel")



func _process(delta: float) -> void:
	if Globals.player != null:
		statuspanel.update()
		weaponpanel.update()
	
	
