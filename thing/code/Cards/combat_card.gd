extends Node
class_name CombatCard

var used = false
var card_data : CardData
var dice_list : Array[CombatDice]

func load_dice():
	dice_list = []
	var data_list := card_data.dice_list
	for n in range(0,data_list.size()):
		var new_dice := CombatDice.new()
		new_dice.dice_slot = n
		new_dice.card_data = card_data
		new_dice.min_roll = data_list[n].min_roll
		new_dice.max_roll = data_list[n].max_roll
		new_dice.dice_type = data_list[n].dice_type
		dice_list.append(new_dice)

func next_dice():
	if dice_list.size() > 0:
		dice_list.remove_at(0)

func reuse_dice():
	if dice_list.size() > 0:
		dice_list.insert(1, dice_list[0])

func recycle_dice():
	if dice_list.size() > 0:
		dice_list.append(dice_list[0])









