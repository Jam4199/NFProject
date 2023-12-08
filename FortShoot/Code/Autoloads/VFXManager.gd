extends Node

var static_delta


func create_vfx(vfx : PackedScene, position : Vector2 , rotation : float = 0) -> VFX:
	var new_vfx = vfx.instantiate()
	
	if not new_vfx is VFX:
		new_vfx.queue_free()
		print("tscn is not VFX")
		return null
	if Globals.VFXLayer == null:
		new_vfx.queue_free()
		return new_vfx
	
	Globals.add_child(new_vfx)
	new_vfx.global_position = position
	new_vfx.global_rotation = rotation
	
	
	return new_vfx
