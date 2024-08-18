extends Resource
class_name TeamData

@export var team_lead : Constants.leaders : set = set_leader

@export var base_limit : int = 4 : set = set_limit
@export var bonus_a : Constants.element
@export var bonus_b : Constants.element

var used_slots : int
var used_bonus_a : bool = false
var used_bonus_b : bool = false 

var character_list : Array[int] = [0, 0, 0, 0, 0, 0, 0, 0, 0]

func add_character(character : Constants.chara) -> bool:
	var success : bool = false
	match character:
		
		Constants.chara.GSD, Constants.chara.FGT, Constants.chara.BMG:
			if bonus_a == Constants.element.SUN and not used_bonus_a:
				used_bonus_a = true
				character_list[character] += 1
				success = true
			elif bonus_b == Constants.element.SUN and not used_bonus_b:
				used_bonus_b = true
				character_list[character] += 1
				success = true
		
		Constants.chara.SPR, Constants.chara.ASN, Constants.chara.SMG:
			if bonus_a == Constants.element.LUN and not used_bonus_a:
				used_bonus_a = true
				character_list[character] += 1
				success = true
			elif bonus_b == Constants.element.LUN and not used_bonus_b:
				used_bonus_b = true
				character_list[character] += 1
				success = true
		
		Constants.chara.PRT, Constants.chara.ACH, Constants.chara.LMG:
			if bonus_a == Constants.element.STR and not used_bonus_a:
				used_bonus_a = true
				character_list[character] += 1
				success = true
			elif bonus_b == Constants.element.STR and not used_bonus_b:
				used_bonus_b = true
				character_list[character] += 1
				success = true
		
	if not success:
		if used_slots < base_limit:
			used_slots += 1
			character_list[character] += 1
			success = true
	
	
	return success

func remove_character(character : Constants.chara) -> bool:
	var success : bool = false
	if character_list[character] > 0:
		character_list[character] -= 1
		success = true
	else:
		return false
	if team_lead == Constants.leaders.HRO:
		used_slots -= 1
	var element : Constants.element = Constants.get_character_element(character)

	if element != bonus_a and element != bonus_b:
		used_slots -= 1
	else:
		if bonus_a == bonus_b:
			var same_elements : Array[Constants.chara]= Constants.get_element_characters(element)
			var count : int = 0
			for n in same_elements:
				count += character_list[n]
			if count > 2:
				used_slots -= 1
			else:
				if used_bonus_b:
					used_bonus_b = false
				else:
					used_bonus_a = false
		else:
			var same_elements : Array[Constants.chara]= Constants.get_element_characters(element)
			var count : int = 0
			for n in same_elements:
				count += character_list[n]
			if count > 1:
				used_slots -= 1
			else:
				if bonus_b == element:
					used_bonus_b = false
				else:
					used_bonus_a = false

	
	
	
	return success

func set_leader(new_lead : Constants.leaders):
	match new_lead:
		Constants.leaders.BRS:
			bonus_a = Constants.element.SUN
			bonus_b = Constants.element.SUN
		
		Constants.leaders.AMG:
			bonus_a = Constants.element.SUN
			bonus_b = Constants.element.LUN
		
		Constants.leaders.SNP:
			bonus_a = Constants.element.SUN
			bonus_b = Constants.element.STR
		
		Constants.leaders.GEN:
			bonus_a = Constants.element.LUN
			bonus_b = Constants.element.LUN
		
		Constants.leaders.DRD:
			bonus_a = Constants.element.LUN
			bonus_b = Constants.element.STR
		
		Constants.leaders.GSH:
			bonus_a = Constants.element.STR
			bonus_b = Constants.element.STR
		
		Constants.leaders.HRO:
			base_limit += 2
		

func set_limit(new_limit : int):
	if team_lead == Constants.leaders.HRO:
		new_limit += 2
	base_limit = new_limit

func update_uses():
	for character in range(0, character_list.size()):
		for count in range(0, character_list[character]):
			if bonus_a == Constants.get_character_element(character) and not used_bonus_a:
				used_bonus_a = true
				continue
			if bonus_b == Constants.get_character_element(character) and not used_bonus_b:
				used_bonus_b = true
				continue
			used_slots += 1
	if used_slots > base_limit:
		print("used slot exceeded base limit")

func clear():
	for n in range(0,character_list.size()):
		character_list[n] = 0
	
