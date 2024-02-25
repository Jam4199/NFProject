extends Panel

@onready var healthbar : TextureProgressBar = get_node("HealthBar")
@onready var stam0 : TextureProgressBar = get_node("%stam1")
@onready var stam1 : TextureProgressBar = get_node("%stam2")
@onready var stam2 : TextureProgressBar = get_node("%stam3")

var stambars : Array[TextureProgressBar] = [stam0,stam1,stam2]

func _ready() -> void:
	stambars = [stam0,stam1,stam2]

func update():
	
	healthbar.max_value = Globals.player.max_hp
	healthbar.value = Globals.player.current_hp
	
	for stam in stambars:
		stam.max_value = Globals.player.dash_cooldown
	match Globals.player.dash_count:
		0:
			for stam in stambars:
				stam.value = 0
			stam0.value = Globals.player.dash_cooldown_timer
		1: 
			stam0.value = stam0.max_value
			stam1.value = Globals.player.dash_cooldown_timer
			stam2.value = 0
		2:
			for stam in stambars:
				stam.value = stam.max_value
			stam2.value = Globals.player.dash_cooldown_timer
		3:
			for stam in stambars:
				stam.value = stam.max_value
	
	
	return
