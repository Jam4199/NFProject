extends Control

@onready var statuspanel = get_node("%StatusPanel") 
@onready var weaponpanel = get_node("%WeaponPanel")
@onready var timer = get_node("%Timer")
@onready var gameover : GameOver = get_node("%GameOver")

signal upgrade_selected(upgrade : Upgrade)


func _process(delta: float) -> void:
	if Globals.player != null:
		statuspanel.update()
		weaponpanel.update()
	
	if Globals.world != null:
		var sec : String
		if Globals.world.runprogress.time.y < 10:
			sec = "0" + str(Globals.world.runprogress.time.y)
		else:
			sec = str(Globals.world.runprogress.time.y)
		timer.text = "[center]" + str(Globals.world.runprogress.time.x) + ":" + sec + "[/center]"


