extends Node2D
class_name Controller

@export var move_proximity : float = 20
@export var move_threshold : float = 50
@export_group("Aggressive_Stance")
@export var agg_behavior : behavior = behavior.APPROACH
@export var agg_move_target : targetting = targetting.E_FRONT
@export var agg_action : Action
@export_group("Neutral_Stance")
@export var neu_behavior : behavior = behavior.APPROACH
@export var neu_move_target : targetting = targetting.E_FRONT
@export var neu_action : Action
@export_group("Defensive_Stance")
@export var def_behavior : behavior = behavior.APPROACH
@export var def_move_target : targetting = targetting.E_FRONT
@export var def_action : Action

enum behavior {APPROACH, FORWARD, MAINTAIN, STATIONARY, INTERCEPT, FOCUS}
enum targetting {E_FRONT, E_MID, E_BACK, A_FRONT, A_MID, A_BACK, FREE}
enum stance {AGGRESSIVE, NEUTRAL, DEFENSIVE}
var behaviors : Array[behavior]
var targettings : Array[targetting]


var current_stance : stance = stance.AGGRESSIVE

func _ready() -> void:
	behaviors = [agg_behavior,neu_behavior,def_behavior]
	targettings = [agg_move_target,neu_move_target,def_move_target]

func character_process(delta : float, character : Character):
	if GameState.current_combat == null:
		return
	var move_target_character : Character = null
	var current_behavior : behavior = behaviors[current_stance]
	var current_move_targetting : targetting = targettings[current_stance]
	
	#move_target
	
	match current_move_targetting:
		targetting.E_FRONT, targetting.E_MID, targetting.E_BACK:
			var targets : Array[Character] = GameState.current_combat.get_enemies(character)
			targets = filter_positioning([targetting.E_FRONT,targetting.E_MID,targetting.E_BACK].find(targetting), targets)
			move_target_character = get_closest_target(character, targets)
		targetting.A_FRONT, targetting.A_MID, targetting.A_BACK:
			var targets : Array[Character] = GameState.current_combat.get_allies(character)
			targets = filter_positioning([targetting.A_FRONT,targetting.A_MID,targetting.A_BACK].find(targetting), targets)
			move_target_character = get_closest_target(character, targets)
	
	match current_behavior:
		behavior.APPROACH:
			#default
			if move_target_character == null:
				var possible_targets := GameState.current_combat.get_enemies(character)
				move_target_character = get_closest_target(character,possible_targets)
			#move
			if move_target_character != null:
				if character.position.distance_to(move_target_character.position) > move_proximity:
					character.move_target = move_target_character.position
				else:
					character.move_target = character.position
		
		behavior.FORWARD:
			#default
			var possible_targets : Array[Character] = []
			var closest_target : Character
			for target in GameState.current_combat.get_enemies(character):
				if closest_target == null:
					closest_target = target
				elif closest_target.position.distance_to(character.position) > target.position.distance_to(character.position):
					closest_target = target
				
				match character.side:
					Character.LEFT:
						if target.position.x > character.position.x:
							possible_targets.append(target)
					Character.RIGHT:
						if target.position.x < character.position.x:
							possible_targets.append(target)
			
			if closest_target.position.distance_to(character.position) < move_threshold:
				move_target_character = closest_target
			elif possible_targets.size() > 0:
				move_target_character = get_closest_target(character,possible_targets)
			else:
				move_target_character = closest_target
			
			#move
			if move_target_character != null:
				if character.position.distance_to(move_target_character.position) > move_proximity:
					character.move_target = move_target_character.position
		
		behavior.MAINTAIN:
			#default
			if move_target_character == null:
				var possible_targets : Array[Character]
				match current_move_targetting:
					targetting.E_FRONT, targetting.E_MID,targetting.E_BACK,targetting.FREE:
						possible_targets = GameState.current_combat.get_enemies(character)
					targetting.A_FRONT, targetting.A_MID,targetting.A_BACK:
						possible_targets = GameState.current_combat.get_allies(character)
				move_target_character = get_closest_target(character,possible_targets)
			#move
			if move_target_character != null:
				if character.position.distance_to(move_target_character.position) < move_proximity:
					character.move_target = 20 * Vector2.from_angle(character.position.angle_to_point(move_target_character.position)).rotated(PI)
				if character.position.distance_to(move_target_character.position) > move_threshold:
					character.move_target = move_target_character.position
		
		behavior.INTERCEPT:
			move_target_character = GameState.current_combat.get_advancing_enemy(character)
			
			if move_target_character != null:
				if character.position.distance_to(move_target_character.position) > move_proximity:
					character.move_target = move_target_character.position
		
		behavior.FOCUS:
			#default
			if move_target_character != null and current_move_targetting == targetting.E_BACK:
				var targets : Array[Character] = GameState.current_combat.get_enemies(character)
				targets = filter_positioning(Character.line.MID, targets)
				move_target_character = get_closest_target(character, targets)
			else:
				var possible_targets := GameState.current_combat.get_enemies(character)
				move_target_character = get_closest_target(character,possible_targets)
			
			#move
			if move_target_character != null:
				if character.position.distance_to(move_target_character.position) > move_proximity:
					character.move_target = move_target_character.position
	
	#action_queue
	var action_array : Array[Action] = [agg_action,neu_action,def_action]
	var current_action : Action = action_array[current_stance]
	var action_target : Character
	
	if move_target_character == null:
		return
	
	match current_action.action_target:
		Action.side.ENEMY:
			if move_target_character.side != character.side and character.position.distance_to(move_target_character.position) < move_target_character.hitbox_radius + current_action.action_range:
				action_target = move_target_character
			else:
				var enemies = GameState.current_combat.get_enemies(character)
				for possible_target in enemies:
					if character.position.distance_to(move_target_character.position) < possible_target.hitbox_radius + current_action.action_range:
						if action_target == null:
							action_target = possible_target
						elif character.position.distance_to(action_target.position) > character.position.distance_to(possible_target.position):
							action_target = possible_target
		Action.side.ALLY:
			if move_target_character.side == character.side and character.position.distance_to(move_target_character.position) < move_target_character.hitbox_radius + current_action.action_range:
				action_target = move_target_character
			else:
				var allies = GameState.current_combat.get_allies(character)
				for possible_target in allies:
						if character.position.distance_to(move_target_character.position) < possible_target.hitbox_radius + current_action.action_range:
							if action_target == null:
								action_target = possible_target
							elif character.position.distance_to(action_target.position) > character.position.distance_to(possible_target.position):
								action_target = possible_target
			
	
	if current_behavior == behavior.FOCUS and action_target != move_target_character:
		if character.position.distance_to(move_target_character.position) < move_target_character.hitbox_radius + current_action.action_range:
			action_target = move_target_character
		else:
			action_target = null
	
	
	if action_target != null:
		character.action_queue = current_action
		character.action_target = action_target 
	
	return

#helper functions

func filter_positioning(line : Character.line, characters : Array[Character]) -> Array[Character]:
	var new_array : Array[Character] = []
	for character in characters:
		if character.line_position == line:
			new_array.append(character)
	return new_array

func get_closest_target(character : Character, targets : Array[Character]) -> Character:
	var current_target : Character
	for target in targets:
		if current_target == null:
			current_target = target 
			continue
		if character.position.distance_to(target.position) < character.position.distance_to(current_target.position):
			current_target = target
	return current_target

