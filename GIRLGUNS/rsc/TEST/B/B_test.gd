extends World



func _ready() -> void:
	super()
	Globals.world = self
	var player : Player = get_node("%Player")
	Globals.player = player
	
	
	player.movement_input = true
	player.attack_input = true

