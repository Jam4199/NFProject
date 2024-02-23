extends Camera2D

var follow_point = Node2D

func _physics_process(delta: float) -> void:
	if follow_point != null:
		camera_follow(delta)

func follow_player():
	if Globals.player == null:
		return
	follow_point = Globals.player

func camera_follow(delta : float):
	if follow_point == null:
		return
	if global_position.distance_to(follow_point.global_position) < 2:
		global_position = follow_point.global_position
	return
