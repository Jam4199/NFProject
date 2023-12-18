extends Node
class_name Controller



var unit : Character

@export_group("Generic_Controller")
@export var default_action : Node2D
@export_enum("move_to_target", "target_enter_range", "maintain_max_range", "follow_behind_target", "retreat_from_target")  var move_behavior : int = 0
@export_enum("ally_slot", "closest_enemy", "advancing_enemy", "rearmost_enemy") var move_target : int = 1
@export_range(1,5) var move_target_ally_slot : int = 1
@export var follow_behind_distance : float = 50
@export var taunt_chase_distance : float = 10
@export_enum("closest_enemy", "advancing_enemy", "rearmost_enemy") var attack_targeting : int = 0
@export var focus_movement_target : bool = false
@export var follow_gap : float = 50

var move_target_character : Character

signal after_movement_check

func update():
	
	move_target_character = check_movement_target()
	if move_target_character != null:
		var move_target_position : Vector2 = check_move_target_position()
		unit.move_target_position = move_target_position
	else:
		unit.move_target_position = unit.position
	
	if unit.move_target_position != unit.position:
		unit.moving = true
		if not unit.acting:
			if unit.move_target_position.x > unit.position.x:
				unit.change_facing(1)
			elif unit.move_target_position.x < unit.position.x:
				unit.change_facing(-1)
	else:
		unit.moving = false
	
	emit_signal("after_movement_check")
	
	if unit.can_act():
		attack_check()
	
	return

func check_movement_target() -> Character:
	var target_unit
	match move_target:
		0:
			target_unit = unit.field.get_unit_from_slot(unit.side , move_target_ally_slot)
		1:
			target_unit = unit.field.get_closest_enemy(unit)
		2:
			target_unit = unit.field.get_advancing_enemy(unit.side)
		3:
			target_unit = unit.field.get_rearmost_enemy(unit.side)
	return target_unit

func follow_to_point(target_point : Vector2, gap : float = follow_gap) -> Vector2:
	var move_angle : float = unit.position.angle_to_point(target_point)
	var move_distance : float = unit.position.distance_to(target_point)
	if move_distance < gap:
		
		return unit.position
	else:
		return unit.position + (Vector2.from_angle(move_angle) * (move_distance - gap))

func retreat_from_point(target_point : Vector2, target_gap : float) -> Vector2:
	var move_angle : float = target_point.angle_to_point(unit.position)
	var move_distance : float = unit.position.distance_to(target_point)
	if move_distance < target_gap:
		return unit.position
	else:
		return unit.position + (Vector2.from_angle(move_angle) * target_gap)

func check_move_target_position() -> Vector2:
	var move_target_position : Vector2 = unit.position
	
	if unit.taunt_target != null:
		if unit.position.distance_to(unit.taunt_target.position) - unit.attack_range < taunt_chase_distance:
			move_target_character = unit.taunt_target
	
	#move_target_position = follow_to_point(move_target_character.position,unit.attack_range)
	#move_target_position = move_target_character.position FOR TEST
	
	
	match move_behavior:
		0: #move_to_target
			move_target_position = follow_to_point(move_target_character.position)
		
		1: #target_enter_range
			var distance = unit.position.distance_to(move_target_character.position)
			var attack_range = unit.get_attack_range() + move_target_character.hitbox_radius - unit.hitbox_radius
			if distance > attack_range:
				move_target_position = follow_to_point(move_target_character.position, distance - attack_range)
			elif distance < attack_range - follow_gap:
				move_target_position = retreat_from_point(move_target_character.position, attack_range - follow_gap - distance)
			else:
				move_target_position = unit.position
			
			
		
		2: #maintain_max_range
			if unit.position.distance_to(move_target_position) > unit.attack_range + (follow_gap/2):
				move_target_position = follow_to_point(move_target_character.position, unit.attack_range)
			elif unit.position.distance_to(move_target_character.position) < unit.attack_range - (follow_gap/2):
				move_target_position = retreat_from_point(move_target_character.position, unit.attack_range)
		
		3: #follow_behind_target
			var target_distance : float = move_target_character.side * follow_behind_distance
			move_target_position = follow_to_point(move_target_character.position + Vector2(target_distance,0))
		
		4: #retreat_from_target
			move_target_position = retreat_from_point(move_target_position, 3000) 
		
	return move_target_position

func attack_check():
	
	if unit.taunt_target != null:
		if unit.taunt_target.position.distance_to(unit.position) <= unit.attack_range:
			unit.initiate_attack(unit.taunt_target)
			return
	
	if attack_override() == true:
		return
	
	var target_list : Array = []
	if focus_movement_target == true:
		if unit.can_attack_unit(move_target_character):
			unit.initiate_attack(move_target_character)
		return
	
	for possible_target in unit.field.get_enemies(unit):
		if unit.can_attack_unit(possible_target):
			target_list.append(possible_target)
	
	if target_list == []:
		return
	
	if target_list.size() == 1:
		unit.initiate_attack(target_list[0])
		return
	
	var attack_target : Character
	match attack_targeting:
		0: #closest
			for possible_target in target_list:
				if attack_target == null:
					attack_target = possible_target
					continue
				
				if attack_target.position.distance_to(unit.position) > possible_target.position.distance_to(unit.position):
					attack_target = possible_target
					
			
		1: #advancing
			for possible_target in target_list:
				if attack_target == null:
					attack_target = possible_target
					continue
				if unit.field.unit_advancement(possible_target) > unit.field.unit_advancement(attack_target):
					attack_target = possible_target
			
		2: #rearmost
			for possible_target in target_list:
				if attack_target == null:
					attack_target = possible_target
					continue
				if unit.field.unit_advancement(possible_target) < unit.field.unit_advancement(attack_target):
					attack_target = possible_target
	unit.initiate_attack(attack_target)

func attack_override()->bool:
	return false



