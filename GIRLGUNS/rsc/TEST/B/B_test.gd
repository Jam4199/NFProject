extends World



func _ready() -> void:
	super()
	Globals.world = self
	var player : Player = get_node("%Player")
	Globals.player = player
	
	world_camera.follow_point = Globals.player
	player.movement_input = true
	player.attack_input = true

