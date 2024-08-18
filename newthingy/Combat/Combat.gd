extends Node2D
class_name Combat

@onready var combat_layer : Node2D = get_node("CombatLayer")

@export var field_width : float = 600
@export var field_height : float = 100

enum {LEFT = -1, RIGHT = 1}

var left_team : Team = null
var right_team : Team = null

var front_distance : Array[float] = [100,200]
var mid_distance : Array[float] = [250,350]
var back_distance : Array[float] = [400,550]



var left_spawns : Array[Vector2] = [Vector2(0,0)]	
var right_spawns : Array[Vector2] = [Vector2(0,0)]

var left_characters : Array[Character] = []
var right_characters : Array[Character] = []
	

enum state{IDLE, INIT, INTRO, ACTIVE}
var current_state : state = state.IDLE

var state_timer : float = 0


func _physics_process(delta):
	match current_state:
		state.IDLE:
			return
		state.INTRO:
			state_timer -= delta
			for team in [left_team,right_team]:
				for character in team.get_all_characters():
					character.position.x += (delta * field_width * (-team.faction))
			
			if state_timer <= 0:
				state_input("intro_finish")
			
	return

func state_input(input : String):
	
	match input:
		
		"start":
			for team in [left_team, right_team]:
				if team == null:
					print("missing team")
					return
			state_timer = 1
			current_state = state.INTRO #start
		"intro_finish":
			current_state = state.ACTIVE
			for team in [left_team, right_team]:
				for character in team.get_all_characters():
					character.active_combat = true
		
		

func load_team(team : Team):
	match team.faction:
		LEFT:
			left_team = team
		RIGHT:
			right_team = team
	
	var character_list : Array[Character] = team.character_list.duplicate()
	character_list.append(team.team_leader)
	for character in character_list:
		character.get_parent().remove_child(character)
		combat_layer.add_child(character)
		character.position.y = randf_range(-(field_height - character.hitbox_radius), (field_height - character.hitbox_radius))
		character.position.x = team.faction
		character.side = team.faction
		match character.side:
			LEFT:
				left_characters.append(character)
			RIGHT:
				right_characters.append(character)
				character.sprite.face(SpriteController.side.LEFT)
		match character.line_position:
			Character.line.FRONT:
				character.position.x *= randf_range(front_distance[0],front_distance[1])
			Character.line.MID:
				character.position.x *= randf_range(mid_distance[0],mid_distance[1])
			Character.line.BACK:
				character.position.x *= randf_range(back_distance[0],back_distance[1])
		character.position.x += team.faction * field_width
	
	return




func return_teams():
	for team in [left_team,right_team]:
		team.return_characters()
		team = null


"""
methods for grabbing characters
"""

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


func get_advancing_enemy(character : Character) -> Character:
	var side = - character.side
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

func get_characters_from_side(character_side : int, include_dead : bool = false) -> Array[Character]:
	var character_list : Array[Character] = []
	
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

func get_allies(character : Character) -> Array[Character]:
	return get_characters_from_side(character.side)

func get_enemies(character : Character) -> Array[Character]:
	return get_characters_from_side(-character.side)

