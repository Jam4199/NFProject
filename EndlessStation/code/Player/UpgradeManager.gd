extends Node2D
class_name UpgradeManager


var resource_queue : Array

@export var attachments : Node2D
@export var health_component : HealthComponent
@export var guns : Node2D
@export var starbeam : Node2D
@export var warper : Node2D


func add_part(new_part : ShipPart):
	
	var attach_point : Vector2 = new_part.global_position
	var attach_angle : float = new_part.global_rotation
	
	
	if new_part.shape != null:
		var part_shape = new_part.shape
		new_part.remove_child(part_shape)
		add_child(part_shape)
		reinstall(part_shape,attach_point,attach_angle)
		new_part.shape = null
	
	if new_part.sprite != null:
		var new_sprite = new_part.sprite
		new_part.remove_child(new_sprite)
		attachments.add_child(new_sprite)
		attachments.move_child(new_sprite,0)
		reinstall(new_sprite,attach_point,attach_angle)
		new_part.sprite = null
	
	for stuff in new_part.get_children():
		if stuff is PartResource:
			new_part.remove_child(stuff)
			add_child(stuff)
			reinstall(stuff,attach_point,attach_angle)
			add_resource(stuff)
		
	
	new_part.queue_free()


func reinstall(part : Node2D,position : Vector2, angle : float):
	part.global_position = position
	part.global_rotation = angle

func add_resource(new_resource : PartResource):
	if new_resource.energy_req > 0 and new_resource.material_req > 0:
		resource_queue.append(new_resource)
		return
	activate_resource(new_resource)
	update_queue()

func activate_resource(resource : PartResource):
	for stuff in resource.get_children():
		if stuff is GunPart:
			var gun_point = stuff.global_transform
			resource.remove_child(stuff)
			guns.add_child(stuff)
			stuff.global_transform = gun_point
			guns.add_gun(stuff)
	return

func update_queue():
	if resource_queue.size() < 1:
		return
	var updating : bool = true
	while updating:
		if resource_queue.size() < 1:
			break
		if check_requirements(resource_queue[0]):
			activate_resource(resource_queue[0]);
			resource_queue.remove_at(0)
		else:
			break
		
	return

func check_requirements(resource : PartResource) -> bool:
	#wip
	return false
