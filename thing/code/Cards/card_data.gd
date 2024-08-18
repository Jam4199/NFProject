extends Resource
class_name CardData

@export var ui_name : String = "Card"
@export var base_mana_cost : int = 1

@export var dice_list : Array[CardDice]

@export var card_text : String
@export var dice_text : Array[String]

enum {on_clash, clash_win, clash_lose, one_side, on_hit}
enum {on_combat_start, on_use}

func dice_effect(dice_slot : int, trigger : int, caster : ActionSlot,target : ActionSlot):
	match dice_slot:
		0:
			match trigger:
				on_clash:
					return

func card_effect(trigger : int, caster :ActionSlot ,target : ActionSlot):
	match trigger:
		on_use:
			return














