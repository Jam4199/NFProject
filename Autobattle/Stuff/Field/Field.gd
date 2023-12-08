extends Node2D
class_name Field


@onready var active_layer : Node2D = get_node("ActiveLayer")

@export var field_width : float = 600

enum {LEFT = -1, RIGHT = 1}

var left_team : Team = null
var right_team : Team = null

var left_spawns : Array[Vector2] = [Vector2(0,0)]
var right_spawns : Array[Vector2] = [Vector2(0,0)]

var left_units : Array[Unit] = []
var right_units : Array[Unit] = []
	
var active_combat : bool = false

var unit_signal_list : Array[String] = [
	"unit_died"
]

var left_alive : int = 0
var right_alive : int = 0

signal combat_ended

func _ready() -> void:
	randomize()
	for point in get_node("SpawnMarkers").get_node("Right").get_children():
		
		right_spawns.append(point.position)
	for point in get_node("SpawnMarkers").get_node("Left").get_children():
		left_spawns.append(point.position)

	pass 

func _physics_process(delta: float) -> void:
	if active_combat:
		check_living_units()
		if left_alive <= 0 or right_alive <= 0:
			combat_end()

func deploy_teams(initiator : Team, targeted : Team):
	if left_team != null or right_team != null:
		print("teams already present")
		return
	
	left_team = initiator
	right_team = targeted
	for unit_info in initiator.team_array:
		deploy_unit(unit_info["unit"], LEFT, unit_info["position"])
		continue
	for unit_info in targeted.team_array:
		deploy_unit(unit_info["unit"], RIGHT, unit_info["position"])
		continue

func deploy_unit(unit : Unit, side : int, slot : int):
	if unit.is_inside_tree():
		unit.get_parent().remove_child(unit)
	active_layer.add_child(unit)
	
	slot = clampi(slot, 1, 9)
	if side == LEFT:
		unit.position = left_spawns[slot]
		left_units.append(unit)
	elif side == RIGHT:
		unit.position = right_spawns[slot]
		right_units.append(unit)
	
	var rand_angle = randf_range(0, 2 * PI)
	var rand_dist = randf_range(0,20)
	unit.position += (Vector2.from_angle(rand_angle) * rand_dist)
	
	unit.field_activated = active_combat
	unit.side = side
	unit.deploy(self)

	return

func combat_start():
	active_combat = true
	for unit in left_units:
		unit.field_activated = true
	for unit in right_units:
		unit.field_activated = true

func combat_end():
	active_combat = false
	for unit in left_units:
		unit.field_activated = false
	for unit in right_units:
		unit.field_activated = false
	emit_signal("combat_ended")

func close_field():
	left_team.return_units()
	right_team.return_units()
	for node in active_layer.get_children():
		node.queue_free()
	return

"""
Running Combat
"""

func check_living_units():
	left_alive= 0
	for unit in left_units:
		if unit.is_alive():
			left_alive += 1
	right_alive = 0
	for unit in right_units:
		if unit.is_alive():
			right_alive += 1

func create_projectile(projectile : Node2D , spawn_position : Vector2):
	active_layer.add_child(projectile)
	projectile.position = spawn_position
	return

func create_VFX(VFX : Node2D, spawn_position):
	active_layer.add_child(VFX)
	VFX.position = spawn_position
	return 

"""
methods for grabbing units
"""

func get_unit_from_slot(unit_side : int, unit_slot : int) -> Unit:
	var unit_list = get_units_from_side(unit_side)
	if unit_list.size() == 0:
		print("empty unit_side")
		return null
		
	if unit_slot <= 0:
		return unit_list[1]
	if (unit_slot + 1) >= unit_list.size():
		return unit_list[unit_list.size() -1]
	return unit_list[unit_slot + 1]

func get_closest_enemy(unit : Unit) -> Unit:
	var enemy_list = get_units_from_side(- unit.side)
	if enemy_list == []:
		print("no enemy found")
		return null
	var farthest_distance = enemy_list[0].position.distance_to(unit.position)
	var target_enemy : Unit = enemy_list[0]
	for enemy in enemy_list:
		var unit_distance = unit.position.distance_to(enemy.position)
		if unit_distance < farthest_distance:
			farthest_distance = unit_distance
			target_enemy = enemy
	
	return target_enemy

func get_advancing_enemy(unit_side : int) -> Unit:
	var side = - unit_side
	var enemy_list = get_units_from_side(side)
	if enemy_list.size() == 0:
		print("no enemy found")
		return null
	var target_enemy : Unit = enemy_list[0]
	var current_advancement : float = field_width - abs(target_enemy.position.x +  (side * field_width/2))
	for enemy in enemy_list:
		var advancement : float = field_width - abs(target_enemy.position.x + (side * field_width/2))
		if advancement > current_advancement:
			current_advancement = advancement
			target_enemy = enemy
	return target_enemy

func get_rearmost_enemy(unit_side : int) -> Unit:
	var side = - unit_side
	var enemy_list = get_units_from_side(side)
	if enemy_list.size() == 0:
		print("no enemy found")
		return null
	var target_enemy : Unit = enemy_list[0]
	var current_advancement : float = field_width - abs(target_enemy.position.x +  (side * field_width/2))
	for enemy in enemy_list:
		var advancement : float = field_width - abs(target_enemy.position.x + (side * field_width/2))
		if advancement < current_advancement:
			current_advancement = advancement
			target_enemy = enemy
	return target_enemy

func unit_advancement(unit : Unit) -> float: #for target acquisition
	return field_width - abs(unit.position.x + (unit.side * field_width/2))

func get_units_from_side(unit_side : int, include_dead : bool = false) -> Array:
	var unit_list : Array = []
	
	var check_unit = func check_unit(unit : Unit):
		if include_dead == false and unit.is_alive() == false:
			return
		unit_list.append(unit)

	if unit_side == -1:
		for unit in left_units:
			check_unit.call(unit)
	elif unit_side == 1:
		for unit in right_units:
			check_unit.call(unit)

	return unit_list 


func get_enemies(unit : Unit) -> Array:
	return get_units_from_side(-unit.side)


