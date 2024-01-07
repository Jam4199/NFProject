extends Node2D
class_name Field


@onready var active_layer : Node2D = get_node("ActiveLayer")

@export var field_width : float = 600

enum {LEFT = -1, RIGHT = 1}

var left_team : Team = null
var right_team : Team = null

var left_spawns : Array[Vector2] = [Vector2(0,0)]
var right_spawns : Array[Vector2] = [Vector2(0,0)]

var left_characters : Array[Character] = []
var right_characters : Array[Character] = []
	
var active_combat : bool = false

var character_signal_list : Array[String] = [
	"character_died"
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
		check_living_characters()
		if left_alive <= 0 or right_alive <= 0:
			combat_end()

func deploy_teams(initiator : Team, targeted : Team):
	if left_team != null or right_team != null:
		print("teams already present")
		return
	
	left_team = initiator
	right_team = targeted
	for character_info in initiator.team_array:
		deploy_character(character_info["character"], LEFT, character_info["position"])
		continue
	for character_info in targeted.team_array:
		deploy_character(character_info["character"], RIGHT, character_info["position"])
		continue

func deploy_character(character : Character, side : int, slot : int):
	if character.is_inside_tree():
		character.get_parent().remove_child(character)
	active_layer.add_child(character)
	
	slot = clampi(slot, 1, 9)
	if side == LEFT:
		character.position = left_spawns[slot]
		left_characters.append(character)
	elif side == RIGHT:
		character.position = right_spawns[slot]
		right_characters.append(character)
	
	var rand_angle = randf_range(0, 2 * PI)
	var rand_dist = randf_range(0,20)
	character.position += (Vector2.from_angle(rand_angle) * rand_dist)
	
	character.field_activated = active_combat
	character.side = side
	character.deploy(self)

	return

func combat_start():
	active_combat = true
	for character in left_characters:
		character.field_activated = true
	for character in right_characters:
		character.field_activated = true

func combat_end():
	active_combat = false
	for character in left_characters:
		character.field_activated = false
	for character in right_characters:
		character.field_activated = false
	emit_signal("combat_ended")

func close_field():
	left_team.return_characters()
	right_team.return_characters()
	for node in active_layer.get_children():
		node.queue_free()
	return

"""
Running Combat
"""

func check_living_characters():
	left_alive= 0
	for character in left_characters:
		if character.is_alive():
			left_alive += 1
	right_alive = 0
	for character in right_characters:
		if character.is_alive():
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
methods for grabbing characters
"""

func get_character_from_slot(character_side : int, character_slot : int) -> Character:
	var character_list = get_characters_from_side(character_side)
	if character_list.size() == 0:
		print("empty character_side")
		return null
		
	if character_slot <= 0:
		return character_list[1]
	if (character_slot + 1) >= character_list.size():
		return character_list[character_list.size() -1]
	return character_list[character_slot + 1]

func get_closest_enemy(character : Character) -> Character:
	var enemy_list = get_characters_from_side(- character.side)
	if enemy_list == []:
		print("no enemy found")
		return null
	var farthest_distance = enemy_list[0].position.distance_to(character.position)
	var target_enemy : Character = enemy_list[0]
	for enemy in enemy_list:
		var character_distance = character.position.distance_to(enemy.position)
		if character_distance < farthest_distance:
			farthest_distance = character_distance
			target_enemy = enemy
	
	return target_enemy

func get_advancing_enemy(character_side : int) -> Character:
	var side = - character_side
	var enemy_list = get_characters_from_side(side)
	if enemy_list.size() == 0:
		print("no enemy found")
		return null
	var target_enemy : Character = enemy_list[0]
	var current_advancement : float = field_width - abs(target_enemy.position.x +  (side * field_width/2))
	for enemy in enemy_list:
		var advancement : float = field_width - abs(target_enemy.position.x + (side * field_width/2))
		if advancement > current_advancement:
			current_advancement = advancement
			target_enemy = enemy
	return target_enemy

func get_rearmost_enemy(character_side : int) -> Character:
	var side = - character_side
	var enemy_list = get_characters_from_side(side)
	if enemy_list.size() == 0:
		print("no enemy found")
		return null
	var target_enemy : Character = enemy_list[0]
	var current_advancement : float = field_width - abs(target_enemy.position.x +  (side * field_width/2))
	for enemy in enemy_list:
		var advancement : float = field_width - abs(target_enemy.position.x + (side * field_width/2))
		if advancement < current_advancement:
			current_advancement = advancement
			target_enemy = enemy
	return target_enemy

func character_advancement(character : Character) -> float: #for target acquisition
	return field_width - abs(character.position.x + (character.side * field_width/2))

func get_characters_from_side(character_side : int, include_dead : bool = false) -> Array:
	var character_list : Array = []
	
	var check_character = func check_character(character : Character):
		if include_dead == false and character.is_alive() == false:
			return
		character_list.append(character)

	if character_side == -1:
		for character in left_characters:
			check_character.call(character)
	elif character_side == 1:
		for character in right_characters:
			check_character.call(character)

	return character_list 


func get_enemies(character : Character) -> Array:
	return get_characters_from_side(-character.side)


