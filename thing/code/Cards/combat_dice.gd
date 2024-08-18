extends CardDice
class_name CombatDice

var rolled_dice : int = 0
var damage_mod : int = 0
var power : int = 0
var tags : Array[String] = []


var card_data : CardData = null
var dice_slot : int = -1

func roll_dice():
	if min_roll >= max_roll:
		rolled_dice = min_roll
	else:
		rolled_dice = randi_range(min_roll,max_roll)
		return

func final_power() -> int:
	var value : int = rolled_dice + power
	if value < 0:
		value = 0
	return value

func  final_damage() -> int:
	return final_power() + damage_mod










