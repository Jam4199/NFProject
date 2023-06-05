extends HitBox


@export var manager : UpgradeManager

func area_check(area : Area2D):
	super(area)
	if area is ShipPart:
		print(area.get_path())
		
		call_deferred("attach_part",area)
	

func attach_part(new_part : ShipPart):

	manager.add_part(new_part)
	

