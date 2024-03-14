extends Control

@onready var statuspanel = get_node("%StatusPanel") 
@onready var weaponpanel = get_node("%WeaponPanel")
@onready var timer = get_node("%Timer")

signal upgrade_selected(upgrade : Upgrade)

func _process(delta: float) -> void:
	if Globals.player != null:
		statuspanel.update()
		weaponpanel.update()
	
	if Globals.world != null:
		timer.text = "[center]" + str(floori(Globals.world.runprogress.raw_time)) + "[/center]"


