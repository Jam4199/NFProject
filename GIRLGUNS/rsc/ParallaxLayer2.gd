extends ParallaxLayer

func _physics_process(delta: float) -> void:
	if Globals.world != null:
		if Globals.world.process_mode != PROCESS_MODE_DISABLED:
			motion_offset.y += 100 * delta
